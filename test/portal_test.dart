import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hospital_core/hospital_core.dart';
import 'package:provider/provider.dart';
import 'package:portal_app/src/launch_targets.dart';
import 'package:portal_app/src/portal_app.dart';
import 'package:portal_app/src/portal_home.dart';

void main() {
  group('launch targets', () {
    test('fall back to the hosted sites when nothing is configured', () {
      final targets = LaunchTargets.resolve();

      expect(
        targets.urlFor(HospitalApp.ehr),
        'https://my-hospital-ehr.procaryote.com',
      );
      expect(
        targets.urlFor(HospitalApp.device),
        'https://my-hospital-dev.procaryote.com',
      );
    });

    test('a query parameter beats a dart-define', () {
      final targets = LaunchTargets.resolve(
        defines: <HospitalApp, String>{HospitalApp.ehr: 'https://from-define'},
        query: <String, String>{'ehr': 'http://localhost:8081'},
      );

      expect(targets.urlFor(HospitalApp.ehr), 'http://localhost:8081');
    });

    test('an empty override does not blank out the compiled default', () {
      // A bare "?ehr=" in the address bar must not send the student nowhere.
      final targets = LaunchTargets.resolve(
        defines: <HospitalApp, String>{HospitalApp.ehr: 'https://from-define'},
        query: <String, String>{'ehr': ''},
      );

      expect(targets.urlFor(HospitalApp.ehr), 'https://from-define');
    });

    test('a trailing slash does not survive into the composed link', () {
      final targets = LaunchTargets.resolve(
        query: <String, String>{'adt': 'http://localhost:8082/'},
      );

      expect(targets.urlFor(HospitalApp.adt), 'http://localhost:8082');
    });

    test('each device link carries its own identifier', () {
      final targets = LaunchTargets.resolve();

      expect(targets.urlForDevice(7), contains('device=DEV7'));
      expect(
        targets.urlForDevice(7),
        startsWith('https://my-hospital-dev.procaryote.com'),
      );
    });

    test('backend and auth are carried onto every link', () {
      final targets = LaunchTargets.resolve(
        query: <String, String>{'backend': 'restApi', 'auth': 'firebase'},
      );

      final ehr = Uri.parse(targets.urlFor(HospitalApp.ehr));
      expect(ehr.queryParameters['backend'], 'restApi');
      expect(ehr.queryParameters['auth'], 'firebase');

      final device = Uri.parse(targets.urlForDevice(3));
      expect(device.queryParameters['backend'], 'restApi');
      expect(device.queryParameters['device'], 'DEV3');
    });

    test('api is deliberately not carried, because it is per application', () {
      // Each application has its own API service. Forwarding one shared value
      // would point four of the five at the wrong database.
      final targets = LaunchTargets.resolve(
        query: <String, String>{'api': 'https://one-api.example'},
      );

      expect(targets.urlFor(HospitalApp.ehr), isNot(contains('api=')));
    });

    test('the host is shown, with the port when there is one', () {
      final targets = LaunchTargets.resolve(
        query: <String, String>{'pharm': 'http://localhost:8083'},
      );

      expect(targets.hostFor(HospitalApp.pharm), 'localhost:8083');
      expect(
        targets.hostFor(HospitalApp.ehr),
        'my-hospital-ehr.procaryote.com',
      );
    });
  });

  group('the page', () {
    Future<void> pump(WidgetTester tester, {LaunchTargets? targets}) async {
      // Tall enough for the whole page. The body is a ListView, so anything
      // below the fold is simply not built, and the device buttons at the
      // bottom would not be found on the default 800px viewport.
      tester.view.physicalSize = const Size(1400, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // The language switcher in the masthead reads the controller off the
      // tree, so the page cannot be mounted bare.
      await tester.pumpWidget(
        ChangeNotifierProvider<LocaleController>(
          create: (_) => LocaleController(store: InMemoryLocaleStore()),
          child: MaterialApp(
            locale: SupportedLocales.english,
            supportedLocales: SupportedLocales.all,
            localizationsDelegates: PortalApp.delegates,
            home: PortalHome(targets: targets ?? LaunchTargets.resolve()),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('lists all five applications', (WidgetTester tester) async {
      await pump(tester);

      expect(find.text('Electronic Health Record'), findsOneWidget);
      expect(find.text('Admission, Transfer & Discharge'), findsOneWidget);
      expect(find.text('Pharmacy Cabinet'), findsOneWidget);
      expect(find.text('Interoperability Server'), findsOneWidget);
      expect(find.text('Device Simulator'), findsOneWidget);
    });

    testWidgets('offers one button per student device', (
      WidgetTester tester,
    ) async {
      await pump(tester);

      for (var number = 1; number <= LaunchTargets.deviceCount; number++) {
        expect(find.text('DEV$number'), findsOneWidget);
      }
    });

    testWidgets('offers a way into the administration console', (
      WidgetTester tester,
    ) async {
      await pump(tester);

      expect(find.text('Administration'), findsOneWidget);
      expect(find.text('Accounts'), findsOneWidget);
    });

    testWidgets('shows where each link goes before it is clicked', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        targets: LaunchTargets.resolve(
          query: <String, String>{'ehr': 'http://localhost:8081'},
        ),
      );

      expect(find.text('localhost:8081'), findsOneWidget);
    });
  });
}
