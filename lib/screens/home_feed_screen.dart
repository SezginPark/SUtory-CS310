import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/post.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_spacing.dart';
import '../widgets/empty_state.dart';
import '../widgets/pill_dropdown.dart';
import '../widgets/post_card.dart';
import '../widgets/responsive_center.dart';

/// Wireframe 3 - Home Feed. Posts from all communities as cards, with a
/// Sort dropdown (New / Vote Count). Shown inside the main shell.
class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  PostSort _sort = PostSort.newest;

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final List<Post> posts = state.posts(sort: _sort);

    return ResponsiveCenter(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.fabClearance,
        ),
        // Item 0 is the sort button, the posts follow.
        itemCount: posts.isEmpty ? 2 : posts.length + 1,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: AppSpacing.md);
        },
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Align(
              alignment: Alignment.centerRight,
              child: PillDropdown<PostSort>(
                label: 'Sort',
                value: _sort,
                options: <PostSort, String>{
                  for (final PostSort sort in PostSort.values) sort: sort.label,
                },
                onSelected: (PostSort sort) => setState(() => _sort = sort),
              ),
            );
          }
          if (posts.isEmpty) {
            return const EmptyState(
              icon: Icons.forum_outlined,
              message: 'No posts yet. Tap + to write the first one.',
            );
          }
          final Post post = posts[index - 1];
          return PostCard(
            key: ValueKey<String>(post.id),
            post: post,
            onTap: () => AppRoutes.openPost(context, post.id),
          );
        },
      ),
    );
  }
}
