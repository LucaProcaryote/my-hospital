import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/generated/portal_localizations.dart';

/// Opens a link, and says so plainly when it cannot.
///
/// A launcher whose links silently do nothing is worse than one that admits
/// failure: on the web a blocked pop-up is the usual cause, and the student
/// needs to be told that rather than left clicking again.
Future<void> openLink(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final l10n = PortalLocalizations.of(context);

  var opened = false;
  try {
    opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  } catch (_) {
    opened = false;
  }

  if (!opened) {
    messenger?.showSnackBar(
      SnackBar(content: Text(l10n.portalUnreachable(url))),
    );
  }
}
