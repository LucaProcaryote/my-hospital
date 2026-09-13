/// Where the administration API lives.
///
/// Same two-step configuration as everything else in the hospital: compiled in
/// for the hosted portal, overridable per visitor so a lab session can point
/// at a laptop.
///
///   --dart-define=ADMIN_API_URL=https://mini-hospital-api-ehr-xxxx.run.app
///   ?admin=http://localhost:8081
///
/// Unset means there is no console: the portal says so rather than showing
/// buttons that cannot work.
class AdminConfig {
  const AdminConfig({required this.apiBase});

  /// The origin of the API service that mounts `/admin`, without a trailing
  /// slash and without the `/admin` itself.
  final String apiBase;

  bool get isConfigured => apiBase.isNotEmpty;

  static const String queryKey = 'admin';
  static const String _define = String.fromEnvironment('ADMIN_API_URL');

  factory AdminConfig.resolve({
    String define = _define,
    Map<String, String> query = const <String, String>{},
  }) {
    final fromQuery = query[queryKey];
    final chosen = (fromQuery != null && fromQuery.isNotEmpty)
        ? fromQuery
        : define;
    return AdminConfig(apiBase: _trim(chosen));
  }

  static String _trim(String url) {
    var value = url.trim();
    while (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    // Tolerate someone pasting the whole endpoint rather than the origin.
    if (value.endsWith('/admin')) {
      value = value.substring(0, value.length - '/admin'.length);
    }
    return value;
  }

  Uri endpoint(String path) => Uri.parse('$apiBase/admin$path');
}
