import 'package:flutter/material.dart';

/// Shared spacing scale. Every padding/gap in the app uses these values.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Default padding around the content of a screen.
  static const EdgeInsets screen = EdgeInsets.all(lg);

  /// Content never grows wider than this, so large phones and tablets
  /// keep a readable column instead of stretching edge to edge.
  static const double maxContentWidth = 600;

  /// Extra bottom padding for lists that sit under a floating action button.
  static const double fabClearance = 88;
}

/// Shared corner radii.
class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;
}
