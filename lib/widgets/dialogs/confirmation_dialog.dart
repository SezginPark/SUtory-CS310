import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../app_buttons.dart';

/// Shows a confirmation dialog after a form was submitted successfully
/// (sign up, new post, edited post). Completes when the user taps the button.
Future<void> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String buttonLabel = 'OK',
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        scrollable: true,
        icon: const Icon(
          Icons.check_circle_outline,
          color: AppColors.primary,
          size: 40,
        ),
        title: Text(title, textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          PillFilledButton(
            label: buttonLabel,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      );
    },
  );
}
