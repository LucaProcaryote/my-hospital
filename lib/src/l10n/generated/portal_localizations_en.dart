// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'portal_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class PortalLocalizationsEn extends PortalLocalizations {
  PortalLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get portalTagline => 'A teaching hospital you can click through.';

  @override
  String get portalIntro =>
      'Five applications sharing one patient population. Open them side by side and watch an admission in ADT reach the record in EHR.';

  @override
  String get portalApplications => 'Applications';

  @override
  String get portalDevices => 'Connected devices';

  @override
  String get portalDevicesBody =>
      'Ten simulators, one per student. Each publishes weight, temperature, heart rate, oxygen saturation and activity.';

  @override
  String get portalOpen => 'Open';

  @override
  String get portalOpensNewTab => 'Opens in a new tab';

  @override
  String get portalDescEhr =>
      'Patient file, prescriptions, observations and clinical notes.';

  @override
  String get portalDescAdt =>
      'Admissions, transfers and discharges, on a live bed board.';

  @override
  String get portalDescPharm =>
      'The cabinet: stock, controlled drugs and dispensing.';

  @override
  String get portalDescEai =>
      'FHIR resources, messages, and a visual editor for integration flows.';

  @override
  String get portalDescDevice =>
      'Vital-sign simulators, and readings from a connected watch.';

  @override
  String portalDeviceNumber(int number) {
    return 'Device $number';
  }

  @override
  String get portalSource => 'Source code';

  @override
  String portalUnreachable(String url) {
    return 'Could not open $url';
  }
}
