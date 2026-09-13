// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'portal_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class PortalLocalizationsFr extends PortalLocalizations {
  PortalLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get portalTagline => 'Un hôpital pédagogique, à portée de clic.';

  @override
  String get portalIntro =>
      'Cinq applications qui partagent une même population de patients. Ouvrez-les côte à côte et suivez une admission de l’ADT jusqu’au dossier.';

  @override
  String get portalApplications => 'Applications';

  @override
  String get portalDevices => 'Appareils connectés';

  @override
  String get portalDevicesBody =>
      'Dix simulateurs, un par étudiant. Chacun publie poids, température, fréquence cardiaque, saturation en oxygène et activité.';

  @override
  String get portalOpen => 'Ouvrir';

  @override
  String get portalOpensNewTab => 'S’ouvre dans un nouvel onglet';

  @override
  String get portalDescEhr =>
      'Dossier patient, prescriptions, observations et notes cliniques.';

  @override
  String get portalDescAdt =>
      'Admissions, transferts et sorties, sur un tableau des lits.';

  @override
  String get portalDescPharm => 'L’armoire : stock, stupéfiants et délivrance.';

  @override
  String get portalDescEai =>
      'Ressources FHIR, messages, et un éditeur visuel de flux d’intégration.';

  @override
  String get portalDescDevice =>
      'Simulateurs de signes vitaux, et relevés d’une montre connectée.';

  @override
  String portalDeviceNumber(int number) {
    return 'Appareil $number';
  }

  @override
  String get portalSource => 'Code source';

  @override
  String portalUnreachable(String url) {
    return 'Impossible d’ouvrir $url';
  }
}
