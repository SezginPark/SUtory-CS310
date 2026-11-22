import 'package:flutter/material.dart';

/// Shared color palette for the whole app (dark purple theme from the
/// Step 2.1 wireframes). Use these instead of hard-coded colors.
class AppColors {
  AppColors._();

  /// Screen background.
  static const Color background = Color(0xFF2A2438);

  /// Cards, inputs, bottom bar and dialogs.
  static const Color surface = Color(0xFF352F44);

  /// Borders, dividers and avatar placeholders.
  static const Color border = Color(0xFF5C5470);

  /// Light lavender used for primary buttons and selected pills.
  static const Color primary = Color(0xFFDBD8E3);

  /// Text/icon color on top of [primary].
  static const Color onPrimary = Color(0xFF2A2438);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB9B4C7);

  /// Inline validation errors.
  static const Color error = Color(0xFFF28FA2);
}
