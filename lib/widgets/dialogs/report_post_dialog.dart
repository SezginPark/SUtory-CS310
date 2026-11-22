import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../app_buttons.dart';

/// Reasons a user can pick when reporting a post.
enum ReportReason {
  spam('Spam'),
  harassment('Harassment'),
  inappropriate('Inappropriate content'),
  other('Other');

  const ReportReason(this.label);
  final String label;
}

/// Dialog for reporting another user's post. The user must pick a reason;
/// picking "Other" reveals a text box for an optional description.
///
/// Pops with the selected [ReportReason], or with null when cancelled.
class ReportPostDialog extends StatefulWidget {
  const ReportPostDialog({super.key});

  @override
  State<ReportPostDialog> createState() => _ReportPostDialogState();
}

class _ReportPostDialogState extends State<ReportPostDialog> {
  final TextEditingController _detailsController = TextEditingController();
  ReportReason? _reason;
  bool _showError = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_reason == null) {
      setState(() => _showError = true);
      return;
    }
    Navigator.of(context).pop(_reason);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Report post'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Why are you reporting this?'),
            const SizedBox(height: AppSpacing.sm),
            for (final ReportReason reason in ReportReason.values)
              _ReasonOption(
                label: reason.label,
                isSelected: _reason == reason,
                onTap: () => setState(() {
                  _reason = reason;
                  _showError = false;
                }),
              ),
            if (_reason == ReportReason.other) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _detailsController,
                minLines: 2,
                maxLines: 4,
                style: AppTextStyles.body,
                decoration: const InputDecoration(
                  hintText: 'Please describe the problem... (optional)',
                  fillColor: AppColors.background,
                ),
              ),
            ],
            if (_showError) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              const Text('Please select a reason', style: AppTextStyles.error),
            ],
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        SecondaryButton(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        ),
        PillFilledButton(label: 'Report', onPressed: _submit),
      ],
    );
  }
}

/// One selectable row with a radio-style icon.
class _ReasonOption extends StatelessWidget {
  const _ReasonOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: <Widget>[
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Opens the report dialog and shows a confirmation message after a valid
/// report. There is no moderation backend in Step 2.2.
Future<void> showReportDialog(BuildContext context) async {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

  final ReportReason? reason = await showDialog<ReportReason>(
    context: context,
    builder: (BuildContext dialogContext) => const ReportPostDialog(),
  );
  if (reason == null) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('Report submitted (${reason.label}). Thank you!'),
      ),
    );
}
