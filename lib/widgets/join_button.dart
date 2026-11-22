import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// "Join" / "Joined" toggle for a community.
/// Outlined while not joined, filled once joined.
class JoinButton extends StatelessWidget {
  const JoinButton(
      {super.key, required this.isJoined, required this.onPressed});

  final bool isJoined;
  final VoidCallback onPressed;

  static const Size _size = Size(84, 36);
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
  );

  @override
  Widget build(BuildContext context) {
    if (isJoined) {
      return FilledButton(
        style: FilledButton.styleFrom(
          minimumSize: _size,
          padding: _padding,
          shape: const StadiumBorder(),
          textStyle: AppTextStyles.pill,
        ),
        onPressed: onPressed,
        child: const Text('Joined'),
      );
    }
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: _size,
        padding: _padding,
        textStyle: AppTextStyles.pill,
      ),
      onPressed: onPressed,
      child: const Text('Join'),
    );
  }
}
