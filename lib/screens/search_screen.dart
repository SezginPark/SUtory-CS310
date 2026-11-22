import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/community.dart';
import '../models/post.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/community_tile.dart';
import '../widgets/empty_state.dart';
import '../widgets/pill_dropdown.dart';
import '../widgets/post_card.dart';
import '../widgets/responsive_center.dart';

/// Wireframe 8 - Search. Searches the placeholder posts and communities
/// while the user types. The Show dropdown filters the results to All,
/// Posts or Communities. Shown inside the main shell.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  SearchFilter _filter = SearchFilter.all;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final String query = _queryController.text;

    final List<Post> posts = _filter == SearchFilter.communities
        ? const <Post>[]
        : state.searchPosts(query);
    final List<Community> communities = _filter == SearchFilter.posts
        ? const <Community>[]
        : state.searchCommunities(query);
    final bool nothingFound = posts.isEmpty && communities.isEmpty;

    return ResponsiveCenter(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: TextField(
              controller: _queryController,
              textInputAction: TextInputAction.search,
              style: AppTextStyles.body,
              onChanged: (String value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search posts or communities',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Clear search',
                        onPressed: () {
                          _queryController.clear();
                          setState(() {});
                        },
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Align(
              alignment: Alignment.centerLeft,
              child: PillDropdown<SearchFilter>(
                label: 'Show',
                value: _filter,
                options: <SearchFilter, String>{
                  for (final SearchFilter filter in SearchFilter.values)
                    filter: filter.label,
                },
                onSelected: (SearchFilter filter) {
                  setState(() => _filter = filter);
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (nothingFound)
            EmptyState(
              icon: Icons.search_off,
              message: 'No results for "${query.trim()}".',
            ),
          if (posts.isNotEmpty) _SectionLabel('Posts (${posts.length})'),
          for (final Post post in posts)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: PostCard(
                key: ValueKey<String>(post.id),
                post: post,
                onTap: () => AppRoutes.openPost(context, post.id),
              ),
            ),
          if (communities.isNotEmpty)
            _SectionLabel('Communities (${communities.length})'),
          for (final Community community in communities) ...<Widget>[
            CommunityTile(
              key: ValueKey<String>(community.id),
              community: community,
              onTap: () => AppRoutes.openCommunity(context, community.id),
            ),
            const Divider(indent: AppSpacing.lg, endIndent: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(text, style: AppTextStyles.meta),
    );
  }
}
