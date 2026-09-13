import 'package:hospital_core/hospital_core.dart';

/// Where each application lives, and what to carry across when opening it.
///
/// The defaults are the five Firebase Hosting sites, so the portal works with
/// no configuration at all. Anything can be overridden two ways, which is the
/// same pattern the applications themselves use:
///
/// * at build time — `--dart-define=EHR_URL=http://localhost:8081`
/// * per visitor — `?ehr=http://localhost:8081`
///
/// The second is what makes a lab session possible: a student running the
/// stack locally opens the hosted portal with their own URLs in the query
/// string, and every link on the page points at their machine.
class LaunchTargets {
  const LaunchTargets({required this.urls, this.backend, this.auth});

  /// The base URL of each application, without a query string.
  final Map<HospitalApp, String> urls;

  /// Carried onto every link when set, so the whole hospital can be pointed at
  /// a real backend from one place.
  ///
  /// Note that `api` is deliberately *not* carried: each application has its
  /// own API service, so a single shared value would send four of the five to
  /// the wrong one.
  final String? backend;
  final String? auth;

  static const Map<HospitalApp, String> defaultUrls = <HospitalApp, String>{
    HospitalApp.ehr: 'https://my-hospital-ehr.procaryote.com',
    HospitalApp.adt: 'https://my-hospital-adt.procaryote.com',
    HospitalApp.pharm: 'https://my-hospital-pharm.procaryote.com',
    HospitalApp.eai: 'https://my-hospital-eai.procaryote.com',
    HospitalApp.device: 'https://my-hospital-dev.procaryote.com',
  };

  /// The query-string key that overrides each application's URL.
  static const Map<HospitalApp, String> queryKeys = <HospitalApp, String>{
    HospitalApp.ehr: 'ehr',
    HospitalApp.adt: 'adt',
    HospitalApp.pharm: 'pharm',
    HospitalApp.eai: 'eai',
    HospitalApp.device: 'device',
  };

  static const String _ehr = String.fromEnvironment('EHR_URL');
  static const String _adt = String.fromEnvironment('ADT_URL');
  static const String _pharm = String.fromEnvironment('PHARM_URL');
  static const String _eai = String.fromEnvironment('EAI_URL');
  static const String _deviceUrl = String.fromEnvironment('DEVICE_URL');

  /// How many device simulators the fleet has - DEV1 to DEV10, one per student.
  static const int deviceCount = 10;

  factory LaunchTargets.fromEnvironment() => LaunchTargets.resolve(
    defines: const <HospitalApp, String>{
      HospitalApp.ehr: _ehr,
      HospitalApp.adt: _adt,
      HospitalApp.pharm: _pharm,
      HospitalApp.eai: _eai,
      HospitalApp.device: _deviceUrl,
    },
    query: AppConfig.queryOverrides(),
  );

  factory LaunchTargets.resolve({
    Map<HospitalApp, String> defines = const <HospitalApp, String>{},
    Map<String, String> query = const <String, String>{},
  }) {
    String pick(HospitalApp app) {
      final fromQuery = query[queryKeys[app]];
      if (fromQuery != null && fromQuery.isNotEmpty) return fromQuery;
      final fromDefine = defines[app];
      if (fromDefine != null && fromDefine.isNotEmpty) return fromDefine;
      return defaultUrls[app]!;
    }

    String? passthrough(String key) {
      final value = query[key];
      return (value == null || value.isEmpty) ? null : value;
    }

    return LaunchTargets(
      urls: <HospitalApp, String>{
        for (final app in HospitalApp.values)
          app: _withoutTrailingSlash(pick(app)),
      },
      backend: passthrough('backend'),
      auth: passthrough('auth'),
    );
  }

  static String _withoutTrailingSlash(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;

  /// The link for one application.
  String urlFor(HospitalApp app) => _compose(app, const <String, String>{});

  /// The link for one device simulator. `DEV1` … `DEV10` are the identifiers
  /// the seeded fleet uses, so this lines up with the devices already in the
  /// database.
  String urlForDevice(int number) =>
      _compose(HospitalApp.device, <String, String>{'device': 'DEV$number'});

  String _compose(HospitalApp app, Map<String, String> extra) {
    final parameters = <String, String>{
      if (backend != null) 'backend': backend!,
      if (auth != null) 'auth': auth!,
      ...extra,
    };
    final base = urls[app]!;
    if (parameters.isEmpty) return base;
    return Uri.parse(base).replace(queryParameters: parameters).toString();
  }

  /// The host, for showing under each card so it is obvious where a link goes
  /// before it is clicked - especially once someone has overridden them.
  String hostFor(HospitalApp app) {
    final uri = Uri.tryParse(urls[app]!);
    if (uri == null || uri.host.isEmpty) return urls[app]!;
    return uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
  }
}
