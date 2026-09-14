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

  @override
  String get adminTitle => 'Administration';

  @override
  String get adminIntro =>
      'Créez les personnes qui se connectent, et décidez de ce que chacune a le droit de faire.';

  @override
  String get adminUnavailableTitle =>
      'Aucune API d\'administration n\'est configurée';

  @override
  String get adminUnavailableBody =>
      'Les comptes ne peuvent être gérés que par un serveur : attribuer un rôle revient à écrire un custom claim, ce qui exige des identifiants qu\'aucune page web ne peut détenir. Déployez l\'API et indiquez-la au portail via ADMIN_API_URL, ou ajoutez ?admin=<url> à cette adresse. En attendant, utilisez Dev_Central/tools/setup_firebase_auth.sh.';

  @override
  String get adminFirebaseMissingTitle =>
      'Firebase n\'est pas configuré dans cette version';

  @override
  String get adminFirebaseMissingBody =>
      'La console vous connecte via Firebase avant de parler à l\'API. Cette version a été compilée sans les clés du projet : il n\'y a personne pour se connecter.';

  @override
  String get adminSignInTitle => 'Connectez-vous comme administrateur';

  @override
  String get adminSignInBody =>
      'Seul un compte dont le rôle est administrateur peut gérer les autres.';

  @override
  String get adminEmail => 'E-mail';

  @override
  String get adminPassword => 'Mot de passe';

  @override
  String get adminSignIn => 'Se connecter';

  @override
  String get adminSignOut => 'Se déconnecter';

  @override
  String get adminNotAdminTitle =>
      'Ce compte ne peut pas administrer l\'hôpital';

  @override
  String adminNotAdminBody(String role) {
    return 'Vous êtes connecté comme $role. Demandez à un administrateur de changer votre rôle, ou connectez-vous avec le compte administrateur.';
  }

  @override
  String adminSignedInAs(String email) {
    return 'Connecté comme $email';
  }

  @override
  String get adminAccounts => 'Comptes';

  @override
  String get adminRefresh => 'Actualiser';

  @override
  String get adminAddUser => 'Nouveau compte';

  @override
  String get adminDisplayName => 'Nom';

  @override
  String get adminRole => 'Rôle';

  @override
  String get adminNoRole => 'Aucun rôle (se connecte comme étudiant)';

  @override
  String get adminEnabled => 'Actif';

  @override
  String get adminDisabled => 'Désactivé';

  @override
  String get adminLastSignIn => 'Dernière connexion';

  @override
  String get adminNever => 'Jamais';

  @override
  String get adminCreate => 'Créer';

  @override
  String get adminCancel => 'Annuler';

  @override
  String get adminNewPassword => 'Nouveau mot de passe';

  @override
  String get adminSetPassword => 'Changer le mot de passe';

  @override
  String get adminDelete => 'Supprimer';

  @override
  String get adminDeleteTitle => 'Supprimer ce compte ?';

  @override
  String adminDeleteBody(String email) {
    return '$email ne pourra plus se connecter nulle part. Ses enregistrements dans les bases de données de l\'hôpital ne sont pas touchés.';
  }

  @override
  String get adminPasswordRule => 'Au moins huit caractères.';

  @override
  String get adminRoleTakesEffect =>
      'Le nouveau rôle s\'applique à la prochaine connexion.';

  @override
  String get adminNoAccounts => 'Aucun compte pour l\'instant.';

  @override
  String get adminSaved => 'Enregistré.';

  @override
  String get adminRequired => 'Obligatoire';

  @override
  String get adminErrorEmailExists =>
      'Un compte existe déjà avec cette adresse.';

  @override
  String get adminErrorWeakPassword =>
      'Ce mot de passe est trop court - huit caractères au minimum.';

  @override
  String get adminErrorSelf =>
      'Vous ne pouvez pas faire cela sur votre propre compte. Quelqu\'un doit rester administrateur.';

  @override
  String get adminErrorUnreachable =>
      'L\'API d\'administration n\'a pas répondu. Vérifiez l\'adresse et que le service tourne.';

  @override
  String get adminErrorNotAdmin =>
      'L\'API a refusé : ce compte n\'est pas administrateur.';

  @override
  String adminErrorGeneric(String code) {
    return 'L\'API a refusé : $code';
  }

  @override
  String get adminShowPassword => 'Afficher le mot de passe';

  @override
  String get adminHidePassword => 'Masquer le mot de passe';
}
