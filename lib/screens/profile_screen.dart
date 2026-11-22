import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/app_user.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../widgets/empty_state.dart';
import '../widgets/pill_tabs.dart';
import '../widgets/post_card.dart';
import '../widgets/responsive_center.dart';
import '../widgets/user_avatar.dart';

/// Wireframe 9 - Profile. The user's info and karma, with tabs for their
/// own posts and comments, and a Log out link. Shown inside the main shell.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// 0 = Posts, 1 = Comments.
  int _tab = 0;

  void _logOut() {
    AppStateScope.read(context).selectTab(0);
    AppRoutes.logOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final AppUser user = state.currentUser;
    final List<Post> posts = state.myPosts;
    final List<Comment> comments = state.myComments;

    return ResponsiveCenter(
      child: ListView(
        padding: AppSpacing.screen,
        children: <Widget>[
          const SizedBox(height: AppSpacing.sm),
          Center(child: UserAvatar(name: user.username, radius: 40)),
          const SizedBox(height: AppSpacing.md),
          Text(
            user.handle,
            style: AppTextStyles.heading,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Joined ${Formatters.monthYear(user.joinedAt)} · '
            '${user.karma} karma',
            style: AppTextStyles.meta,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          PillTabs(
            labels: <String>[
              'Posts (${posts.length})',
              'Comments (${comments.length})',
            ],
            selectedIndex: _tab,
            onSelected: (int index) => setState(() => _tab = index),
          ),
          const SizedBox(height: AppSpacing.md),
          if (_tab == 0) ...<Widget>[
            if (posts.isEmpty)
              const EmptyState(
                icon: Icons.article_outlined,
                message: 'You have not posted anything yet.',
              ),
            for (final Post post in posts)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: PostCard(
                  key: ValueKey<String>(post.id),
                  post: post,
                  onTap: () => AppRoutes.openPost(context, post.id),
                ),
              ),
          ] else ...<Widget>[
            if (comments.isEmpty)
              const EmptyState(
                icon: Icons.chat_bubble_outline,
                message: 'You have not commented on anything yet.',
              ),
            for (final Comment comment in comments)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _ProfileCommentCard(
                  key: ValueKey<String>(comment.id),
                  comment: comment,
                  postTitle: state.postById(comment.postId)?.title ?? '',
                  onTap: () => AppRoutes.openPost(context, comment.postId),
                ),
              ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton(
              onPressed: _logOut,
              child: const Text(
                'Log out',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One of the user's comments on the profile, with the post it belongs to.
class _ProfileCommentCard extends StatelessWidget {
  const _ProfileCommentCard({
    super.key,
    required this.comment,
    required this.postTitle,
    required this.onTap,
  });

  final Comment comment;
  final String postTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'On: $postTitle',
                style: AppTextStyles.meta,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(comment.content, style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${comment.score} points · '
                '${Formatters.timeAgo(comment.createdAt)}',
                style: AppTextStyles.meta,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
