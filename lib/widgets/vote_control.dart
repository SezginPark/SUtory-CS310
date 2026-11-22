import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';

/// Up arrow, score and down arrow. Vertical on post cards, horizontal on
/// comments. The arrow of the user's current vote is highlighted.
class VoteControl extends StatelessWidget {
  const VoteControl({
    super.key,
    required this.score,
    required this.userVote,
    required this.onUpvote,
    required this.onDownvote,
    this.axis = Axis.vertical,
  });

  final int score;

  /// 1 = upvoted, -1 = downvoted, 0 = no vote.
  final int userVote;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      _VoteArrow(
        icon: Icons.arrow_drop_up,
        tooltip: 'Upvote',
        isActive: userVote == 1,
        onPressed: onUpvote,
      ),
      Text(
        Formatters.compactCount(score),
        style: AppTextStyles.label.copyWith(
          color:
              userVote == 0 ? AppColors.textSecondary : AppColors.textPrimary,
        ),
      ),
      _VoteArrow(
        icon: Icons.arrow_drop_down,
        tooltip: 'Downvote',
        isActive: userVote == -1,
        onPressed: onDownvote,
      ),
    ];

    if (axis == Axis.horizontal) {
      return Row(mainAxisSize: MainAxisSize.min, children: children);
    }
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}

class _VoteArrow extends StatelessWidget {
  const _VoteArrow({
    required this.icon,
    required this.tooltip,
    required this.isActive,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 28,
      tooltip: tooltip,
      color: isActive ? AppColors.textPrimary : AppColors.border,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 28),
      // Keep the arrows close to the score, as in the wireframes.
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
    );
  }
}
