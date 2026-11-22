import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/community.dart';
import '../models/post.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/empty_state.dart';
import '../widgets/join_button.dart';
import '../widgets/pill_dropdown.dart';
import '../widgets/post_card.dart';
import '../widgets/responsive_center.dart';

/// Wireframe 5 - Community Page. One community's description and posts,
/// with the same Sort dropdown as the Home Feed. The "+" button opens
/// Create Post with this community pre-selected.
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key, required this.communityId});

  final String communityId;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  PostSort _sort = PostSort.newest;

  /// A tap on the bottom bar switches the tab and returns to the main app.
  void _onTabTapped(int index) {
    AppStateScope.read(context).selectTab(index);
    AppRoutes.backToMain(context);
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final Community? community = state.communityById(widget.communityId);

    if (community == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Community')),
        body: const Center(
          child: EmptyState(
            icon: Icons.groups_outlined,
            message: 'This community does not exist.',
          ),
        ),
      );
    }

    final List<Post> posts = state.posts(
      communityId: community.id,
      sort: _sort,
    );

    return Scaffold(
      appBar: AppBar(title: Text(community.displayName)),
      body: SafeArea(
        child: ResponsiveCenter(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.fabClearance,
            ),
            // Item 0 is the header, item 1 the sort button, then the posts.
            itemCount: posts.isEmpty ? 3 : posts.length + 2,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: AppSpacing.md);
            },
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _CommunityHeader(
                  community: community,
                  onJoinPressed: () => state.toggleJoin(community.id),
                );
              }
              if (index == 1) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: PillDropdown<PostSort>(
                    label: 'Sort',
                    value: _sort,
                    options: <PostSort, String>{
                      for (final PostSort sort in PostSort.values)
                        sort: sort.label,
                    },
                    onSelected: (PostSort sort) => setState(() => _sort = sort),
                  ),
                );
              }
              if (posts.isEmpty) {
                return const EmptyState(
                  icon: Icons.forum_outlined,
                  message: 'No posts here yet. Tap + to write the first one.',
                );
              }
              final Post post = posts[index - 2];
              return PostCard(
                key: ValueKey<String>(post.id),
                post: post,
                showCommunity: false,
                onTap: () => AppRoutes.openPost(context, post.id),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'community-new-post',
        tooltip: 'New post in ${community.displayName}',
        onPressed: () {
          AppRoutes.openPostForm(context, communityId: community.id);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: 1, onTap: _onTabTapped),
    );
  }
}

/// Card at the top of the community page: name, description, member count
/// and the Join / Joined button.
class _CommunityHeader extends StatelessWidget {
  const _CommunityHeader({
    required this.community,
    required this.onJoinPressed,
  });

  final Community community;
  final VoidCallback onJoinPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(community.displayName, style: AppTextStyles.heading),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${community.description} · '
              '${Formatters.compactCount(community.memberCount)} members',
              style: AppTextStyles.meta,
            ),
            const SizedBox(height: AppSpacing.sm),
            JoinButton(
              isJoined: community.isJoined,
              onPressed: onJoinPressed,
            ),
          ],
        ),
      ),
    );
  }
}
