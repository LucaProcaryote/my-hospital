import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:hospital_core/hospital_core.dart';
import 'package:provider/provider.dart';

import 'l10n/generated/portal_localizations.dart';
import 'portal_home.dart';

/// The front door.
///
/// Deliberately not built on [MiniHospitalApp]: the portal has no repository,
/// no authentication and no patient data - it is a page of links. What it does
/// share is the design system and the language switcher, so the door looks
/// like the rooms behind it.
class PortalApp extends StatefulWidget {
  const PortalApp({super.key, this.localeStore});

  /// Injectable so a test can start from a known language without reaching for
  /// browser storage, which never answers under `flutter_test`.
  final LocalePreferenceStore? localeStore;

  /// The portal's own strings, then the shared ones it borrows for the
  /// application names and the language switcher. Exposed so a widget test can
  /// mount a page with the same localisations the application uses.
  static const List<LocalizationsDelegate<dynamic>> delegates =
      <LocalizationsDelegate<dynamic>>[
        PortalLocalizations.delegate,
        ...HospitalLocalizations.localizationsDelegates,
      ];

  @override
  State<PortalApp> createState() => _PortalAppState();
}

class _PortalAppState extends State<PortalApp> {
  late final LocaleController _locale;

  @override
  void initState() {
    super.initState();
    _locale = LocaleController(store: widget.localeStore);
    // Restoring the saved language is not allowed to hold up the first frame:
    // the controller settles on a usable language synchronously and notifies
    // again if storage answers with a different one.
    _locale.load(deviceLocale: PlatformDispatcher.instance.locale);
  }

  @override
  void dispose() {
    _locale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocaleController>.value(
      value: _locale,
      child: Consumer<LocaleController>(
        builder: (BuildContext context, LocaleController locale, _) {
          return MaterialApp(
            title: 'Mini-Hospital 2026',
            debugShowCheckedModeBanner: false,
            theme: HospitalTheme.light(),
            darkTheme: HospitalTheme.dark(),
            locale: locale.locale,
            supportedLocales: SupportedLocales.all,
            localizationsDelegates: PortalApp.delegates,
            home: const PortalHome(),
          );
        },
      ),
    );
  }
}
