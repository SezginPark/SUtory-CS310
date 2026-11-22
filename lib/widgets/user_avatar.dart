import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Round placeholder avatar showing the first letter of a name.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.name, this.radius = 20});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final String initial = name.isEmpty ? '?' : name[0].toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.border,
      child: Text(
        initial,
        style: AppTextStyles.heading.copyWith(fontSize: radius * 0.9),
      ),
    );
  }
}
