import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/community.dart';
import '../models/post.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import 'dialogs/delete_post_dialog.dart';
import 'dialogs/report_post_dialog.dart';
import 'post_image.dart';
import 'vote_control.dart';

/// A [Post] shown as a Card: votes on the left, then the meta line, title,
/// content, optional network image and the action row.
///
/// The action row shows **Report** on other users' posts and **Delete**
/// on the current user's own posts. The same card is reused on the Home
/// Feed, Community Page, Search, Profile and Post Detail screens.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.showCommunity = true,
    this.expanded = false,
    this.onEdit,
    this.onDeleted,
  });

  final Post post;

  /// Called when the card is tapped (opens Post Detail from the lists).
  final VoidCallback? onTap;

  /// Whether the meta line starts with the community name.
  final bool showCommunity;

  /// When true the whole content is shown (Post Detail). Otherwise the
  /// content is cut after two lines.
  final bool expanded;

  /// When set, an **Edit** action is shown on the user's own posts.
  final VoidCallback? onEdit;

  /// Called after the user confirmed deleting this post.
  final VoidCallback? onDeleted;

  Future<void> _delete(BuildContext context) async {
    final bool deleted = await confirmAndDeletePost(context, post);
    if (deleted) onDeleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final AppUser author = state.userById(post.authorId);
    final Community? community = state.communityById(post.communityId);
    final bool isOwn = state.isOwnPost(post);
    final int commentCount = state.commentCount(post.id);

    final String meta = <String>[
      if (showCommunity && community != null) community.displayName,
      Formatters.timeAgo(post.createdAt),
      isOwn ? '${author.handle} (you)' : author.handle,
    ].join(' · ');

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              VoteControl(
                score: post.score,
                userVote: post.userVote,
                onUpvote: () => state.votePost(post.id, 1),
                onDownvote: () => state.votePost(post.id, -1),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      meta,
                      style: AppTextStyles.meta,
                      maxLines: expanded ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      post.title,
                      style: AppTextStyles.cardTitle,
                      maxLines: expanded ? null : 2,
                      overflow: expanded ? null : TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      post.content,
                      style: AppTextStyles.bodyMuted,
                      maxLines: expanded ? null : 2,
                      overflow: expanded ? null : TextOverflow.ellipsis,
                    ),
                    if (post.hasImage) ...<Widget>[
                      const SizedBox(height: AppSpacing.sm),
                      PostImage(url: post.imageUrl!),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(
                          Formatters.commentCount(commentCount),
                          style: AppTextStyles.meta,
                        ),
                        if (isOwn && onEdit != null)
                          _CardAction(label: 'Edit', onTap: onEdit!),
                        if (isOwn)
                          _CardAction(
                            label: 'Delete',
                            onTap: () => _delete(context),
                          )
                        else
                          _CardAction(
                            label: 'Report',
                            onTap: () => showReportDialog(context),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small text action in the bottom row of a post card, preceded by a dot.
class _CardAction extends StatelessWidget {
  const _CardAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: AppSpacing.sm),
          child: Text('·', style: AppTextStyles.meta),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Text(label, style: AppTextStyles.action),
          ),
        ),
      ],
    );
  }
}
