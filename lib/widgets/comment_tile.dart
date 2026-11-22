import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/app_user.dart';
import '../models/comment.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import 'vote_control.dart';

/// One comment under a post. Replies are indented and marked with an arrow.
class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment, required this.onReply});

  final Comment comment;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final AppUser author = state.userById(comment.authorId);
    final bool isOwn = comment.authorId == SampleData.currentUserId;
    final String meta = '${author.handle}${isOwn ? ' (you)' : ''} · '
        '${Formatters.timeAgo(comment.createdAt)}';

    return Padding(
      padding: EdgeInsets.only(left: comment.isReply ? AppSpacing.xl : 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                if (comment.isReply) ...<Widget>[
                  const Icon(
                    Icons.subdirectory_arrow_right,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Expanded(
                  child: Text(
                    meta,
                    style: AppTextStyles.meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(comment.content, style: AppTextStyles.body),
            Row(
              children: <Widget>[
                VoteControl(
                  axis: Axis.horizontal,
                  score: comment.score,
                  userVote: comment.userVote,
                  onUpvote: () => state.voteComment(comment.id, 1),
                  onDownvote: () => state.voteComment(comment.id, -1),
                ),
                const SizedBox(width: AppSpacing.sm),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: AppTextStyles.action,
                    minimumSize: const Size(48, 36),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                  ),
                  onPressed: onReply,
                  child: const Text('Reply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
