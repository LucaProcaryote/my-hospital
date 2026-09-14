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

  @override
  String get adminTitle => 'Beheer';

  @override
  String get adminIntro =>
      'Maak de mensen aan die zich aanmelden, en bepaal wat elk van hen mag doen.';

  @override
  String get adminUnavailableTitle => 'Er is geen beheer-API geconfigureerd';

  @override
  String get adminUnavailableBody =>
      'Accounts kunnen alleen door een server beheerd worden: iemand een rol geven betekent een custom claim schrijven, en dat vraagt om gegevens die geen enkele webpagina mag bezitten. Rol de API uit en wijs het portaal ernaar met ADMIN_API_URL, of voeg ?admin=<url> toe aan dit adres. Gebruik tot dan Dev_Central/tools/setup_firebase_auth.sh.';

  @override
  String get adminFirebaseMissingTitle =>
      'Firebase is niet geconfigureerd in deze build';

  @override
  String get adminFirebaseMissingBody =>
      'De console meldt u eerst aan bij Firebase voordat ze met de API praat. Deze build is gemaakt zonder de sleutels van het project, dus er is niemand om mee aan te melden.';

  @override
  String get adminSignInTitle => 'Meld u aan als beheerder';

  @override
  String get adminSignInBody =>
      'Alleen een account met de rol beheerder kan de andere accounts beheren.';

  @override
  String get adminEmail => 'E-mail';

  @override
  String get adminPassword => 'Wachtwoord';

  @override
  String get adminSignIn => 'Aanmelden';

  @override
  String get adminSignOut => 'Afmelden';

  @override
  String get adminNotAdminTitle =>
      'Dit account kan het ziekenhuis niet beheren';

  @override
  String adminNotAdminBody(String role) {
    return 'U bent aangemeld als $role. Vraag een beheerder om uw rol te wijzigen, of meld u aan met het beheerdersaccount.';
  }

  @override
  String adminSignedInAs(String email) {
    return 'Aangemeld als $email';
  }

  @override
  String get adminAccounts => 'Accounts';

  @override
  String get adminRefresh => 'Vernieuwen';

  @override
  String get adminAddUser => 'Nieuw account';

  @override
  String get adminDisplayName => 'Naam';

  @override
  String get adminRole => 'Rol';

  @override
  String get adminNoRole => 'Geen rol (meldt zich aan als student)';

  @override
  String get adminEnabled => 'Actief';

  @override
  String get adminDisabled => 'Uitgeschakeld';

  @override
  String get adminLastSignIn => 'Laatste aanmelding';

  @override
  String get adminNever => 'Nooit';

  @override
  String get adminCreate => 'Aanmaken';

  @override
  String get adminCancel => 'Annuleren';

  @override
  String get adminNewPassword => 'Nieuw wachtwoord';

  @override
  String get adminSetPassword => 'Wachtwoord wijzigen';

  @override
  String get adminDelete => 'Verwijderen';

  @override
  String get adminDeleteTitle => 'Dit account verwijderen?';

  @override
  String adminDeleteBody(String email) {
    return '$email kan zich nergens meer aanmelden. De gegevens in de ziekenhuisdatabases blijven ongemoeid.';
  }

  @override
  String get adminPasswordRule => 'Minstens acht tekens.';

  @override
  String get adminRoleTakesEffect =>
      'De nieuwe rol geldt vanaf de volgende aanmelding.';

  @override
  String get adminNoAccounts => 'Nog geen accounts.';

  @override
  String get adminSaved => 'Opgeslagen.';

  @override
  String get adminRequired => 'Verplicht';

  @override
  String get adminErrorEmailExists =>
      'Er bestaat al een account met dat adres.';

  @override
  String get adminErrorWeakPassword =>
      'Dat wachtwoord is te kort - minstens acht tekens.';

  @override
  String get adminErrorSelf =>
      'Dat kunt u niet met uw eigen account doen. Iemand moet beheerder blijven.';

  @override
  String get adminErrorUnreachable =>
      'De beheer-API antwoordde niet. Controleer het adres en of de service draait.';

  @override
  String get adminErrorNotAdmin =>
      'De API weigerde: dit account is geen beheerder.';

  @override
  String adminErrorGeneric(String code) {
    return 'De API weigerde: $code';
  }

  @override
  String get adminShowPassword => 'Wachtwoord tonen';

  @override
  String get adminHidePassword => 'Wachtwoord verbergen';
}
