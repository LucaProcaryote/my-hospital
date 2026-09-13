import 'package:flutter/material.dart';
import 'package:hospital_core/hospital_core.dart';

import '../l10n/generated/portal_localizations.dart';
import '../launch_targets.dart';
import 'open_link.dart';

/// One application: its badge, its name, what it is for, and where it lives.
///
/// The host is shown under the name on purpose. The URLs can be overridden per
/// visitor, so "which hospital am I about to open" has to be answerable before
/// clicking, not after.
class ApplicationCard extends StatelessWidget {
  const ApplicationCard({super.key, required this.app, required this.targets});

  final HospitalApp app;
  final LaunchTargets targets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = PortalLocalizations.of(context);
    final url = targets.urlFor(app);

    return Card(
      child: InkWell(
        onTap: () => openLink(context, url),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(Gap.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  AppBadge(app: app, size: 40),
                  Gap.w16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _title(app, HospitalLocalizations.of(context)),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          targets.hostFor(app),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap.h16,
              Text(_description(app, l10n), style: theme.textTheme.bodyMedium),
              Gap.h16,
              Align(
                alignment: Alignment.centerLeft,
                child: Tooltip(
                  message: l10n.portalOpensNewTab,
                  child: FilledButton.icon(
                    onPressed: () => openLink(context, url),
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: Text(l10n.portalOpen),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _title(HospitalApp app, HospitalLocalizations l10n) =>
      switch (app) {
        HospitalApp.ehr => l10n.appTitleEhr,
        HospitalApp.adt => l10n.appTitleAdt,
        HospitalApp.pharm => l10n.appTitlePharm,
        HospitalApp.eai => l10n.appTitleEai,
        HospitalApp.device => l10n.appTitleDevice,
      };

  static String _description(HospitalApp app, PortalLocalizations l10n) =>
      switch (app) {
        HospitalApp.ehr => l10n.portalDescEhr,
        HospitalApp.adt => l10n.portalDescAdt,
        HospitalApp.pharm => l10n.portalDescPharm,
        HospitalApp.eai => l10n.portalDescEai,
        HospitalApp.device => l10n.portalDescDevice,
      };
}
