import 'package:flutter/material.dart';
import 'package:hospital_core/hospital_core.dart';

import '../l10n/generated/portal_localizations.dart';
import '../launch_targets.dart';
import 'open_link.dart';

/// DEV1 to DEV10, one button each.
///
/// They all open the same hosted build; the device identifier travels in the
/// query string. That is the whole reason the simulator reads `?device=` -
/// ten students, one deployment, no per-student build.
class DeviceLauncher extends StatelessWidget {
  const DeviceLauncher({super.key, required this.targets});

  final LaunchTargets targets;

  @override
  Widget build(BuildContext context) {
    final l10n = PortalLocalizations.of(context);

    return Wrap(
      spacing: Gap.sm,
      runSpacing: Gap.sm,
      children: <Widget>[
        for (var number = 1; number <= LaunchTargets.deviceCount; number++)
          ActionChip(
            avatar: const Icon(Icons.monitor_heart_rounded, size: 18),
            label: Text('DEV$number'),
            tooltip: l10n.portalDeviceNumber(number),
            onPressed: () => openLink(context, targets.urlForDevice(number)),
          ),
      ],
    );
  }
}
