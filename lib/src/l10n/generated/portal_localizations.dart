import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'portal_localizations_en.dart';
import 'portal_localizations_fr.dart';
import 'portal_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of PortalLocalizations
/// returned by `PortalLocalizations.of(context)`.
///
/// Applications need to include `PortalLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/portal_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: PortalLocalizations.localizationsDelegates,
///   supportedLocales: PortalLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the PortalLocalizations.supportedLocales
/// property.
abstract class PortalLocalizations {
  PortalLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static PortalLocalizations of(BuildContext context) {
    return Localizations.of<PortalLocalizations>(context, PortalLocalizations)!;
  }

  static const LocalizationsDelegate<PortalLocalizations> delegate =
      _PortalLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('nl'),
  ];

  /// No description provided for @portalTagline.
  ///
  /// In en, this message translates to:
  /// **'A teaching hospital you can click through.'**
  String get portalTagline;

  /// No description provided for @portalIntro.
  ///
  /// In en, this message translates to:
  /// **'Five applications sharing one patient population. Open them side by side and watch an admission in ADT reach the record in EHR.'**
  String get portalIntro;

  /// No description provided for @portalApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get portalApplications;

  /// No description provided for @portalDevices.
  ///
  /// In en, this message translates to:
  /// **'Connected devices'**
  String get portalDevices;

  /// No description provided for @portalDevicesBody.
  ///
  /// In en, this message translates to:
  /// **'Ten simulators, one per student. Each publishes weight, temperature, heart rate, oxygen saturation and activity.'**
  String get portalDevicesBody;

  /// No description provided for @portalOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get portalOpen;

  /// No description provided for @portalOpensNewTab.
  ///
  /// In en, this message translates to:
  /// **'Opens in a new tab'**
  String get portalOpensNewTab;

  /// No description provided for @portalDescEhr.
  ///
  /// In en, this message translates to:
  /// **'Patient file, prescriptions, observations and clinical notes.'**
  String get portalDescEhr;

  /// No description provided for @portalDescAdt.
  ///
  /// In en, this message translates to:
  /// **'Admissions, transfers and discharges, on a live bed board.'**
  String get portalDescAdt;

  /// No description provided for @portalDescPharm.
  ///
  /// In en, this message translates to:
  /// **'The cabinet: stock, controlled drugs and dispensing.'**
  String get portalDescPharm;

  /// No description provided for @portalDescEai.
  ///
  /// In en, this message translates to:
  /// **'FHIR resources, messages, and a visual editor for integration flows.'**
  String get portalDescEai;

  /// No description provided for @portalDescDevice.
  ///
  /// In en, this message translates to:
  /// **'Vital-sign simulators, and readings from a connected watch.'**
  String get portalDescDevice;

  /// No description provided for @portalDeviceNumber.
  ///
  /// In en, this message translates to:
  /// **'Device {number}'**
  String portalDeviceNumber(int number);

  /// No description provided for @portalSource.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get portalSource;

  /// No description provided for @portalUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Could not open {url}'**
  String portalUnreachable(String url);

  /// No description provided for @adminTitle.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get adminTitle;

  /// No description provided for @adminIntro.
  ///
  /// In en, this message translates to:
  /// **'Create the people who sign in, and decide what each of them is allowed to do.'**
  String get adminIntro;

  /// No description provided for @adminUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'No administration API is configured'**
  String get adminUnavailableTitle;

  /// No description provided for @adminUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'Accounts can only be managed by a server: giving someone a role means writing a custom claim, and that needs credentials no web page may hold. Deploy the API and point the portal at it with ADMIN_API_URL, or add ?admin=<url> to this address. Until then, use Dev_Central/tools/setup_firebase_auth.sh.'**
  String get adminUnavailableBody;

  /// No description provided for @adminFirebaseMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'Firebase is not configured in this build'**
  String get adminFirebaseMissingTitle;

  /// No description provided for @adminFirebaseMissingBody.
  ///
  /// In en, this message translates to:
  /// **'The console signs you in with Firebase before it will talk to the API. This build was made without the project\'s keys, so there is nobody to sign in as.'**
  String get adminFirebaseMissingBody;

  /// No description provided for @adminSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in as an administrator'**
  String get adminSignInTitle;

  /// No description provided for @adminSignInBody.
  ///
  /// In en, this message translates to:
  /// **'Only an account whose role is administrator can manage the others.'**
  String get adminSignInBody;

  /// No description provided for @adminEmail.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get adminEmail;

  /// No description provided for @adminPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get adminPassword;

  /// No description provided for @adminSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get adminSignIn;

  /// No description provided for @adminSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get adminSignOut;

  /// No description provided for @adminNotAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'This account cannot administer the hospital'**
  String get adminNotAdminTitle;

  /// No description provided for @adminNotAdminBody.
  ///
  /// In en, this message translates to:
  /// **'You are signed in as {role}. Ask an administrator to change your role, or sign in with the administrator account.'**
  String adminNotAdminBody(String role);

  /// No description provided for @adminSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String adminSignedInAs(String email);

  /// No description provided for @adminAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get adminAccounts;

  /// No description provided for @adminRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get adminRefresh;

  /// No description provided for @adminAddUser.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get adminAddUser;

  /// No description provided for @adminDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get adminDisplayName;

  /// No description provided for @adminRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get adminRole;

  /// No description provided for @adminNoRole.
  ///
  /// In en, this message translates to:
  /// **'No role (signs in as a student)'**
  String get adminNoRole;

  /// No description provided for @adminEnabled.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminEnabled;

  /// No description provided for @adminDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get adminDisabled;

  /// No description provided for @adminLastSignIn.
  ///
  /// In en, this message translates to:
  /// **'Last sign-in'**
  String get adminLastSignIn;

  /// No description provided for @adminNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get adminNever;

  /// No description provided for @adminCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get adminCreate;

  /// No description provided for @adminCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get adminCancel;

  /// No description provided for @adminNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get adminNewPassword;

  /// No description provided for @adminSetPassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get adminSetPassword;

  /// No description provided for @adminDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get adminDelete;

  /// No description provided for @adminDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this account?'**
  String get adminDeleteTitle;

  /// No description provided for @adminDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'{email} will no longer be able to sign in anywhere. Their records in the hospital databases are not touched.'**
  String adminDeleteBody(String email);

  /// No description provided for @adminPasswordRule.
  ///
  /// In en, this message translates to:
  /// **'At least eight characters.'**
  String get adminPasswordRule;

  /// No description provided for @adminRoleTakesEffect.
  ///
  /// In en, this message translates to:
  /// **'The new role applies the next time they sign in.'**
  String get adminRoleTakesEffect;

  /// No description provided for @adminNoAccounts.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet.'**
  String get adminNoAccounts;

  /// No description provided for @adminSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get adminSaved;

  /// No description provided for @adminRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get adminRequired;

  /// No description provided for @adminErrorEmailExists.
  ///
  /// In en, this message translates to:
  /// **'There is already an account with that address.'**
  String get adminErrorEmailExists;

  /// No description provided for @adminErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'That password is too short - eight characters at least.'**
  String get adminErrorWeakPassword;

  /// No description provided for @adminErrorSelf.
  ///
  /// In en, this message translates to:
  /// **'You cannot do that to your own account. Somebody has to stay an administrator.'**
  String get adminErrorSelf;

  /// No description provided for @adminErrorUnreachable.
  ///
  /// In en, this message translates to:
  /// **'The administration API did not answer. Check the address, and that the service is running.'**
  String get adminErrorUnreachable;

  /// No description provided for @adminErrorNotAdmin.
  ///
  /// In en, this message translates to:
  /// **'The API refused: this account is not an administrator.'**
  String get adminErrorNotAdmin;

  /// No description provided for @adminErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'The API refused: {code}'**
  String adminErrorGeneric(String code);
}

class _PortalLocalizationsDelegate
    extends LocalizationsDelegate<PortalLocalizations> {
  const _PortalLocalizationsDelegate();

  @override
  Future<PortalLocalizations> load(Locale locale) {
    return SynchronousFuture<PortalLocalizations>(
      lookupPortalLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_PortalLocalizationsDelegate old) => false;
}

PortalLocalizations lookupPortalLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return PortalLocalizationsEn();
    case 'fr':
      return PortalLocalizationsFr();
    case 'nl':
      return PortalLocalizationsNl();
  }

  throw FlutterError(
    'PortalLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
