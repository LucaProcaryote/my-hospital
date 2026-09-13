import 'package:flutter/material.dart';

import 'src/portal_app.dart';

/// Entry point of the Mini-Hospital front door.
///
/// The five application URLs default to the Firebase Hosting sites, so this
/// runs with no configuration. Point it somewhere else at build time:
///
/// ```
/// flutter run -d chrome --dart-define=EHR_URL=http://localhost:8081
/// ```
///
/// or per visitor, which is what a lab session uses:
///
/// ```
/// https://my-hospital-2026.web.app/?ehr=http://localhost:8081
/// ```
void main() => runApp(const PortalApp());
