import 'dart:convert';

import 'package:http/http.dart' as http;

import 'admin_config.dart';

/// One account, as the administration API reports it.
class AdminUser {
  const AdminUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    required this.disabled,
    this.lastSignInAt,
  });

  final String uid;
  final String email;
  final String displayName;

  /// Empty when the account has no `role` claim. The applications read that
  /// as a student, and the console says so rather than showing a blank cell.
  final String role;
  final bool disabled;
  final DateTime? lastSignInAt;

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
    uid: json['uid']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    displayName: json['display_name']?.toString() ?? '',
    role: json['role']?.toString() ?? '',
    disabled: json['disabled'] == true,
    lastSignInAt: DateTime.tryParse(json['last_sign_in_at']?.toString() ?? ''),
  );
}

/// An answer the API refused to give, carrying the code it gave instead.
///
/// The codes are passed through unchanged - `EMAIL_EXISTS`,
/// `cannot-demote-yourself`, `not-an-administrator` - because a reader who
/// searches for one finds it in the server source.
class AdminException implements Exception {
  const AdminException(this.code, {this.status});

  final String code;
  final int? status;

  @override
  String toString() => 'AdminException($code)';
}

/// Talks to the `/admin` routes of one API service.
///
/// Every call carries the signed-in administrator's Firebase ID token. There
/// is no other credential in the browser, and no API key that would work on
/// its own - which is the whole reason account management is server-side.
class AdminClient {
  AdminClient({
    required this.config,
    required this.tokenSource,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final AdminConfig config;

  /// Asked for a fresh token before every request rather than held, so a
  /// console left open overnight recovers by itself.
  final Future<String?> Function() tokenSource;

  final http.Client _http;

  Future<List<AdminUser>> users() async {
    final body = await _send('GET', '/users');
    final users = body['users'];
    if (users is! List) return const <AdminUser>[];
    return users
        .cast<Map<String, dynamic>>()
        .map(AdminUser.fromJson)
        .toList(growable: false);
  }

  Future<AdminUser> whoami() async {
    final body = await _send('GET', '/whoami');
    return AdminUser.fromJson(body['user'] as Map<String, dynamic>);
  }

  Future<AdminUser> create({
    required String email,
    required String password,
    required String displayName,
    required String role,
  }) async {
    final body = await _send('POST', '/users', <String, dynamic>{
      'email': email,
      'password': password,
      'display_name': displayName,
      'role': role,
    });
    return AdminUser.fromJson(body['user'] as Map<String, dynamic>);
  }

  Future<void> setRole(String uid, String role) =>
      _send('PATCH', '/users/$uid', <String, dynamic>{'role': role});

  Future<void> setDisabled(String uid, {required bool disabled}) =>
      _send('PATCH', '/users/$uid', <String, dynamic>{'disabled': disabled});

  Future<void> setPassword(String uid, String password) =>
      _send('PATCH', '/users/$uid', <String, dynamic>{'password': password});

  Future<void> delete(String uid) => _send('DELETE', '/users/$uid');

  Future<Map<String, dynamic>> _send(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final token = await tokenSource();
    if (token == null || token.isEmpty) {
      throw const AdminException('not-signed-in');
    }

    final request = http.Request(method, config.endpoint(path))
      ..headers['authorization'] = 'Bearer $token';
    if (body != null) {
      request.headers['content-type'] = 'application/json; charset=utf-8';
      request.body = jsonEncode(body);
    }

    final http.Response response;
    try {
      response = await http.Response.fromStream(await _http.send(request));
    } catch (_) {
      // A wrong address, a service that is not running, or a browser refusing
      // the request for CORS reasons all arrive here indistinguishably.
      throw const AdminException('unreachable');
    }

    Map<String, dynamic> decoded = <String, dynamic>{};
    if (response.body.isNotEmpty) {
      try {
        final json = jsonDecode(response.body);
        if (json is Map<String, dynamic>) decoded = json;
      } on FormatException {
        throw AdminException('bad-response', status: response.statusCode);
      }
    }

    if (response.statusCode >= 400) {
      throw AdminException(
        decoded['error']?.toString() ?? 'http-${response.statusCode}',
        status: response.statusCode,
      );
    }
    return decoded;
  }

  void close() => _http.close();
}
