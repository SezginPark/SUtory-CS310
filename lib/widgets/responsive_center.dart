import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Keeps content in a centered column that never grows wider than
/// [AppSpacing.maxContentWidth]. On phones it has no visible effect; on
/// large screens it stops cards and forms from stretching edge to edge.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppSpacing.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}
