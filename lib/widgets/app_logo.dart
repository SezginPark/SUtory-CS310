import 'package:flutter/material.dart';

/// The SUtory logo, loaded from a local image bundled with the app
/// (`assets/images/sutory_logo.png`).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  static const String assetPath = 'assets/images/sutory_logo.png';

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticLabel: 'SUtory logo',
    );
  }
}
