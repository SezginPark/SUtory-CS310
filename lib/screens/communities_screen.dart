import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/community.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_spacing.dart';
import '../widgets/community_tile.dart';
import '../widgets/responsive_center.dart';

/// Wireframe 4 - Communities. Topic boards with member counts and a
/// Join / Joined toggle. Shown inside the main shell.
class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final List<Community> communities = state.communities;

    return ResponsiveCenter(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount: communities.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(indent: AppSpacing.lg, endIndent: AppSpacing.lg);
        },
        itemBuilder: (BuildContext context, int index) {
          final Community community = communities[index];
          return CommunityTile(
            key: ValueKey<String>(community.id),
            community: community,
            onTap: () => AppRoutes.openCommunity(context, community.id),
            onJoinPressed: () => state.toggleJoin(community.id),
          );
        },
      ),
    );
  }
}
