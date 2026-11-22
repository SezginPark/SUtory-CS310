import 'package:flutter/material.dart';

import '../models/community.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/formatters.dart';
import 'join_button.dart';
import 'user_avatar.dart';

/// One community row: avatar, name, member count and a Join button.
/// Used on the Communities screen and in search results.
class CommunityTile extends StatelessWidget {
  const CommunityTile({
    super.key,
    required this.community,
    required this.onTap,
    this.onJoinPressed,
  });

  final Community community;
  final VoidCallback onTap;

  /// When null the Join button is hidden (search results).
  final VoidCallback? onJoinPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            UserAvatar(name: community.name),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    community.displayName,
                    style: AppTextStyles.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${Formatters.compactCount(community.memberCount)} members',
                    style: AppTextStyles.meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onJoinPressed != null) ...<Widget>[
              const SizedBox(width: AppSpacing.sm),
              JoinButton(
                isJoined: community.isJoined,
                onPressed: onJoinPressed!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
