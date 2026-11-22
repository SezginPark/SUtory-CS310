import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// A form field with its label above it, as in the wireframes.
/// Validation errors are shown inline under the field.
class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.minLines,
    this.maxLines = 1,
    this.onFieldSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          minLines: minLines,
          maxLines: maxLines,
          onFieldSubmitted: onFieldSubmitted,
          style: AppTextStyles.body,
          decoration: InputDecoration(hintText: hintText),
        ),
      ],
    );
  }
}
