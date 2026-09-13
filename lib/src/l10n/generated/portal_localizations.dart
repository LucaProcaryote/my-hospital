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
