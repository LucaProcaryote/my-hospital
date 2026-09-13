import 'package:flutter/material.dart';
import 'package:hospital_core/hospital_core.dart';

import 'l10n/generated/portal_localizations.dart';
import 'launch_targets.dart';
import 'widgets/application_card.dart';
import 'widgets/device_launcher.dart';
import 'widgets/open_link.dart';

/// One page: the five applications, then the ten device simulators.
class PortalHome extends StatelessWidget {
  const PortalHome({super.key, this.targets});

  /// Injectable for tests; in the running application it comes from the
  /// dart-defines and the query string.
  final LaunchTargets? targets;

  static const String repositoryUrl = 'https://github.com/LucaProcaryote';

  @override
  Widget build(BuildContext context) {
    final resolved = targets ?? LaunchTargets.fromEnvironment();
    final theme = Theme.of(context);
    final l10n = PortalLocalizations.of(context);
    final shared = HospitalLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: Gap.lg,
                vertical: Gap.xl,
              ),
              children: <Widget>[
                _Masthead(tagline: l10n.portalTagline),
                Gap.h16,
                Text(l10n.portalIntro, style: theme.textTheme.bodyLarge),
                Gap.h32,

                _SectionHeading(l10n.portalApplications),
                Gap.h16,
                _ApplicationGrid(targets: resolved),

                Gap.h32,
                _SectionHeading(l10n.portalDevices),
                Gap.h8,
                Text(
                  l10n.portalDevicesBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Gap.h16,
                DeviceLauncher(targets: resolved),

                Gap.h32,
                const Divider(),
                Gap.h16,
                _Footer(hospitalName: shared.hospitalName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Title, language switcher, and the five badges - the header shows what is
/// inside rather than inventing a sixth mark for the door itself.
class _Masthead extends StatelessWidget {
  const _Masthead({required this.tagline});

  final String tagline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shared = HospitalLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Wrap(
                spacing: Gap.sm,
                runSpacing: Gap.sm,
                children: <Widget>[
                  for (final app in HospitalApp.values)
                    AppBadge(app: app, size: 34),
                ],
              ),
            ),
            const LanguageSelector(),
          ],
        ),
        Gap.h16,
        Text(
          shared.hospitalName,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(tagline, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

/// Cards that reflow rather than a fixed column count, so the page works on a
/// phone in a corridor and on the projector in the lecture room.
class _ApplicationGrid extends StatelessWidget {
  const _ApplicationGrid({required this.targets});

  final LaunchTargets targets;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const spacing = Gap.md;
        final columns = switch (constraints.maxWidth) {
          >= 900 => 3,
          >= 560 => 2,
          _ => 1,
        };
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: <Widget>[
            for (final app in HospitalApp.values)
              SizedBox(
                width: width,
                child: ApplicationCard(app: app, targets: targets),
              ),
          ],
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.hospitalName});

  final String hospitalName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = PortalLocalizations.of(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            hospitalName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () => openLink(context, PortalHome.repositoryUrl),
          icon: const Icon(Icons.code_rounded, size: 18),
          label: Text(l10n.portalSource),
        ),
      ],
    );
  }
}
