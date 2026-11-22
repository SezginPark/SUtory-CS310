import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Pill-shaped button that opens a dropdown list, e.g. "Sort: New ▾" on the
/// feeds and "Show: All ▾" on the search screen. The selected option has a
/// check mark.
class PillDropdown<T> extends StatelessWidget {
  const PillDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onSelected,
  });

  /// Text before the colon, e.g. "Sort".
  final String label;
  final T value;

  /// Every selectable value with the text shown for it.
  final Map<T, String> options;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      initialValue: value,
      tooltip: '$label options',
      position: PopupMenuPosition.under,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<T>>[
          for (final MapEntry<T, String> option in options.entries)
            PopupMenuItem<T>(
              value: option.key,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.check,
                    size: 18,
                    color: option.key == value
                        ? AppColors.textPrimary
                        : Colors.transparent,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(option.value, style: AppTextStyles.body),
                ],
              ),
            ),
        ];
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.sm,
          top: AppSpacing.xs + 2,
          bottom: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Text(
                '$label: ${options[value]}',
                style: AppTextStyles.pill,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }
}
