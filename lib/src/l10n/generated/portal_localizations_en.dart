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

  @override
  String get adminTitle => 'Administration';

  @override
  String get adminIntro =>
      'Create the people who sign in, and decide what each of them is allowed to do.';

  @override
  String get adminUnavailableTitle => 'No administration API is configured';

  @override
  String get adminUnavailableBody =>
      'Accounts can only be managed by a server: giving someone a role means writing a custom claim, and that needs credentials no web page may hold. Deploy the API and point the portal at it with ADMIN_API_URL, or add ?admin=<url> to this address. Until then, use Dev_Central/tools/setup_firebase_auth.sh.';

  @override
  String get adminFirebaseMissingTitle =>
      'Firebase is not configured in this build';

  @override
  String get adminFirebaseMissingBody =>
      'The console signs you in with Firebase before it will talk to the API. This build was made without the project\'s keys, so there is nobody to sign in as.';

  @override
  String get adminSignInTitle => 'Sign in as an administrator';

  @override
  String get adminSignInBody =>
      'Only an account whose role is administrator can manage the others.';

  @override
  String get adminEmail => 'E-mail';

  @override
  String get adminPassword => 'Password';

  @override
  String get adminSignIn => 'Sign in';

  @override
  String get adminSignOut => 'Sign out';

  @override
  String get adminNotAdminTitle =>
      'This account cannot administer the hospital';

  @override
  String adminNotAdminBody(String role) {
    return 'You are signed in as $role. Ask an administrator to change your role, or sign in with the administrator account.';
  }

  @override
  String adminSignedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get adminAccounts => 'Accounts';

  @override
  String get adminRefresh => 'Refresh';

  @override
  String get adminAddUser => 'New account';

  @override
  String get adminDisplayName => 'Name';

  @override
  String get adminRole => 'Role';

  @override
  String get adminNoRole => 'No role (signs in as a student)';

  @override
  String get adminEnabled => 'Active';

  @override
  String get adminDisabled => 'Disabled';

  @override
  String get adminLastSignIn => 'Last sign-in';

  @override
  String get adminNever => 'Never';

  @override
  String get adminCreate => 'Create';

  @override
  String get adminCancel => 'Cancel';

  @override
  String get adminNewPassword => 'New password';

  @override
  String get adminSetPassword => 'Change password';

  @override
  String get adminDelete => 'Delete';

  @override
  String get adminDeleteTitle => 'Delete this account?';

  @override
  String adminDeleteBody(String email) {
    return '$email will no longer be able to sign in anywhere. Their records in the hospital databases are not touched.';
  }

  @override
  String get adminPasswordRule => 'At least eight characters.';

  @override
  String get adminRoleTakesEffect =>
      'The new role applies the next time they sign in.';

  @override
  String get adminNoAccounts => 'No accounts yet.';

  @override
  String get adminSaved => 'Saved.';

  @override
  String get adminRequired => 'Required';

  @override
  String get adminErrorEmailExists =>
      'There is already an account with that address.';

  @override
  String get adminErrorWeakPassword =>
      'That password is too short - eight characters at least.';

  @override
  String get adminErrorSelf =>
      'You cannot do that to your own account. Somebody has to stay an administrator.';

  @override
  String get adminErrorUnreachable =>
      'The administration API did not answer. Check the address, and that the service is running.';

  @override
  String get adminErrorNotAdmin =>
      'The API refused: this account is not an administrator.';

  @override
  String adminErrorGeneric(String code) {
    return 'The API refused: $code';
  }
}
