import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hospital_core/hospital_core.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:portal_app/src/admin/admin_client.dart';
import 'package:portal_app/src/admin/admin_config.dart';
import 'package:portal_app/src/admin/admin_screen.dart';
import 'package:portal_app/src/portal_app.dart';
import 'package:provider/provider.dart';

/// An authentication service that answers from a field, so the console can be
/// exercised without Firebase.
class FakeAuth extends AuthService {
  FakeAuth({HospitalUser? user, this.token = 'id-token'}) : _user = user;

  HospitalUser? _user;
  final String? token;
  int signInCalls = 0;

  @override
  HospitalUser? get currentUser => _user;

  @override
  bool get isReady => true;

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> idToken() async => _user == null ? null : token;

  @override
  Future<HospitalUser> signIn({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    if (password != 'correct') throw const AuthFailure('invalid-credentials');
    _user = HospitalUser(
      uid: 'uid-admin',
      email: email,
      displayName: 'Administrator',
      role: UserRole.admin,
    );
    notifyListeners();
    return _user!;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    notifyListeners();
  }
}

const HospitalUser _admin = HospitalUser(
  uid: 'uid-admin',
  email: 'admin@mini-hospital.be',
  displayName: 'Hospital Administrator',
  role: UserRole.admin,
);

String _usersPayload() => jsonEncode(<String, dynamic>{
  'users': <Map<String, dynamic>>[
    <String, dynamic>{
      'uid': 'uid-admin',
      'email': 'admin@mini-hospital.be',
      'display_name': 'Hospital Administrator',
      'role': 'admin',
      'disabled': false,
      'last_sign_in_at': null,
    },
    <String, dynamic>{
      'uid': 'uid-nurse',
      'email': 'marie.lambert@mini-hospital.be',
      'display_name': 'Marie Lambert',
      'role': 'nurse',
      'disabled': false,
      'last_sign_in_at': '2026-09-01T08:30:00Z',
    },
  ],
});

void main() {
  group('AdminConfig', () {
    test('is unconfigured when nothing points at an API', () {
      expect(AdminConfig.resolve(define: '').isConfigured, isFalse);
    });

    test('a query parameter beats the compiled-in address', () {
      final config = AdminConfig.resolve(
        define: 'https://compiled.example',
        query: <String, String>{'admin': 'http://localhost:8081'},
      );

      expect(config.apiBase, 'http://localhost:8081');
    });

    test('an empty override does not blank out the compiled address', () {
      final config = AdminConfig.resolve(
        define: 'https://compiled.example',
        query: <String, String>{'admin': ''},
      );

      expect(config.apiBase, 'https://compiled.example');
    });

    test('tolerates a trailing slash and a pasted /admin', () {
      // Both are what somebody actually copies out of the deploy output.
      expect(
        AdminConfig.resolve(define: 'https://api.example/').apiBase,
        'https://api.example',
      );
      expect(
        AdminConfig.resolve(define: 'https://api.example/admin/').apiBase,
        'https://api.example',
      );
    });

    test('composes the endpoint', () {
      final config = AdminConfig.resolve(define: 'https://api.example');

      expect(
        config.endpoint('/users').toString(),
        'https://api.example/admin/users',
      );
    });
  });

  group('AdminClient', () {
    AdminClient clientFor(
      MockClient mock, {
      String? token = 'id-token',
      String base = 'https://api.example',
    }) => AdminClient(
      config: AdminConfig.resolve(define: base),
      tokenSource: () async => token,
      httpClient: mock,
    );

    test('sends the administrator token and parses the list', () async {
      late http.BaseRequest seen;
      final client = clientFor(
        MockClient((http.Request request) async {
          seen = request;
          return http.Response(_usersPayload(), 200);
        }),
      );

      final users = await client.users();

      expect(seen.url.toString(), 'https://api.example/admin/users');
      expect(seen.headers['authorization'], 'Bearer id-token');
      expect(users, hasLength(2));
      expect(users[1].email, 'marie.lambert@mini-hospital.be');
      expect(users[1].lastSignInAt?.toUtc().year, 2026);
      expect(users[0].lastSignInAt, isNull);
    });

    test('refuses to send anything when nobody is signed in', () async {
      var called = false;
      final client = clientFor(
        MockClient((_) async {
          called = true;
          return http.Response('{}', 200);
        }),
        token: null,
      );

      await expectLater(
        client.users(),
        throwsA(
          isA<AdminException>().having((e) => e.code, 'code', 'not-signed-in'),
        ),
      );
      expect(called, isFalse);
    });

    test('passes the API error code through untouched', () async {
      final client = clientFor(
        MockClient(
          (_) async => http.Response(
            jsonEncode(<String, String>{'error': 'not-an-administrator'}),
            403,
          ),
        ),
      );

      await expectLater(
        client.users(),
        throwsA(
          isA<AdminException>()
              .having((e) => e.code, 'code', 'not-an-administrator')
              .having((e) => e.status, 'status', 403),
        ),
      );
    });

    test('a wrong address reads as unreachable, not as a crash', () async {
      // A misconfigured ?admin=, a service that is down and a CORS refusal all
      // land here, and the console has to say something useful about all three.
      final client = clientFor(
        MockClient((_) async => throw const SocketExceptionStub()),
      );

      await expectLater(
        client.users(),
        throwsA(
          isA<AdminException>().having((e) => e.code, 'code', 'unreachable'),
        ),
      );
    });

    test('creating sends the role alongside the account', () async {
      late Map<String, dynamic> body;
      final client = clientFor(
        MockClient((http.Request request) async {
          body = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode(<String, dynamic>{
              'user': <String, dynamic>{
                'uid': 'uid-new',
                'email': 'new@mini-hospital.be',
                'role': 'nurse',
                'disabled': false,
              },
            }),
            201,
          );
        }),
      );

      final created = await client.create(
        email: 'new@mini-hospital.be',
        password: 'Hospital2026!',
        displayName: 'Nieuwe Collega',
        role: 'nurse',
      );

      expect(body['role'], 'nurse');
      expect(body['display_name'], 'Nieuwe Collega');
      expect(created.uid, 'uid-new');
    });
  });

  group('the console', () {
    Future<void> pump(
      WidgetTester tester, {
      required AdminConfig config,
      AuthService? auth,
      AdminClient? client,
    }) async {
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ChangeNotifierProvider<LocaleController>(
          create: (_) => LocaleController(store: InMemoryLocaleStore()),
          child: MaterialApp(
            locale: SupportedLocales.english,
            supportedLocales: SupportedLocales.all,
            localizationsDelegates: PortalApp.delegates,
            home: AdminScreen(config: config, auth: auth, client: client),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('says so when no API is configured, and offers no form', (
      WidgetTester tester,
    ) async {
      await pump(tester, config: AdminConfig.resolve(define: ''));

      expect(find.text('No administration API is configured'), findsOneWidget);
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('asks an anonymous visitor to sign in', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        config: AdminConfig.resolve(define: 'https://api.example'),
        auth: FakeAuth(),
        client: AdminClient(
          config: AdminConfig.resolve(define: 'https://api.example'),
          tokenSource: () async => null,
          httpClient: MockClient((_) async => http.Response('{}', 200)),
        ),
      );

      expect(find.text('Sign in as an administrator'), findsOneWidget);
      expect(find.text('Accounts'), findsNothing);
    });

    testWidgets('turns a signed-in nurse away without calling the API', (
      WidgetTester tester,
    ) async {
      var called = false;
      const nurse = HospitalUser(
        uid: 'uid-nurse',
        email: 'marie.lambert@mini-hospital.be',
        displayName: 'Marie Lambert',
        role: UserRole.nurse,
      );

      await pump(
        tester,
        config: AdminConfig.resolve(define: 'https://api.example'),
        auth: FakeAuth(user: nurse),
        client: AdminClient(
          config: AdminConfig.resolve(define: 'https://api.example'),
          tokenSource: () async => 'id-token',
          httpClient: MockClient((_) async {
            called = true;
            return http.Response('{}', 200);
          }),
        ),
      );

      expect(
        find.text('This account cannot administer the hospital'),
        findsOneWidget,
      );
      expect(called, isFalse);
    });

    testWidgets('lists the accounts for an administrator', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        config: AdminConfig.resolve(define: 'https://api.example'),
        auth: FakeAuth(user: _admin),
        client: AdminClient(
          config: AdminConfig.resolve(define: 'https://api.example'),
          tokenSource: () async => 'id-token',
          httpClient: MockClient(
            (_) async => http.Response(_usersPayload(), 200),
          ),
        ),
      );

      expect(find.text('Hospital Administrator'), findsOneWidget);
      expect(find.text('Marie Lambert'), findsOneWidget);
      // Roles are shown with the shared, translated names rather than the
      // claim string.
      expect(find.text('Nurse'), findsOneWidget);
    });

    testWidgets('an unreachable API is explained, not swallowed', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        config: AdminConfig.resolve(define: 'https://api.example'),
        auth: FakeAuth(user: _admin),
        client: AdminClient(
          config: AdminConfig.resolve(define: 'https://api.example'),
          tokenSource: () async => 'id-token',
          httpClient: MockClient(
            (_) async => throw const SocketExceptionStub(),
          ),
        ),
      );

      expect(
        find.textContaining('The administration API did not answer'),
        findsOneWidget,
      );
    });

    testWidgets('a wrong password is reported on the sign-in form', (
      WidgetTester tester,
    ) async {
      final auth = FakeAuth();
      await pump(
        tester,
        config: AdminConfig.resolve(define: 'https://api.example'),
        auth: auth,
        client: AdminClient(
          config: AdminConfig.resolve(define: 'https://api.example'),
          tokenSource: () async => null,
          httpClient: MockClient((_) async => http.Response('{}', 200)),
        ),
      );

      await tester.enterText(
        find.byType(TextFormField).first,
        'admin@mini-hospital.be',
      );
      await tester.enterText(find.byType(TextFormField).last, 'wrong');
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(auth.signInCalls, 1);
      expect(find.textContaining('invalid-credentials'), findsOneWidget);
    });
  });
}

/// A transport failure, without depending on dart:io so the test also runs
/// under the web test runner.
class SocketExceptionStub implements Exception {
  const SocketExceptionStub();
}
