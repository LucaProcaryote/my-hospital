// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'portal_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class PortalLocalizationsNl extends PortalLocalizations {
  PortalLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get portalTagline => 'Een leerziekenhuis op klikafstand.';

  @override
  String get portalIntro =>
      'Vijf toepassingen met dezelfde patiëntenpopulatie. Open ze naast elkaar en volg een opname van ADT tot in het dossier.';

  @override
  String get portalApplications => 'Toepassingen';

  @override
  String get portalDevices => 'Verbonden apparaten';

  @override
  String get portalDevicesBody =>
      'Tien simulatoren, één per student. Elk publiceert gewicht, temperatuur, hartslag, zuurstofsaturatie en activiteit.';

  @override
  String get portalOpen => 'Openen';

  @override
  String get portalOpensNewTab => 'Opent in een nieuw tabblad';

  @override
  String get portalDescEhr =>
      'Patiëntendossier, voorschriften, observaties en klinische notities.';

  @override
  String get portalDescAdt =>
      'Opnames, transfers en ontslagen, op een bedbord.';

  @override
  String get portalDescPharm =>
      'De kast: voorraad, verdovende middelen en aflevering.';

  @override
  String get portalDescEai =>
      'FHIR-resources, berichten en een visuele editor voor integratiestromen.';

  @override
  String get portalDescDevice =>
      'Simulatoren voor vitale parameters en metingen van een smartwatch.';

  @override
  String portalDeviceNumber(int number) {
    return 'Apparaat $number';
  }

  @override
  String get portalSource => 'Broncode';

  @override
  String portalUnreachable(String url) {
    return 'Kan $url niet openen';
  }
}
