import 'package:flutter/material.dart';

/// Full-width light button used for the main action of a screen
/// ("Log In", "Sign Up", "Post").
class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(onPressed: onPressed, child: Text(label)),
    );
  }
}

/// Outlined pill button used for the secondary action in dialogs ("Cancel").
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onPressed, child: Text(label));
  }
}

/// Filled pill button used for the confirming action in dialogs
/// ("Delete", "Report", "OK").
class PillFilledButton extends StatelessWidget {
  const PillFilledButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(shape: const StadiumBorder()),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
