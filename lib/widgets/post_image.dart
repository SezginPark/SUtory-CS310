import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// An image loaded from a network URL, shown in a fixed 16:9 box.
///
/// While the image loads a spinner is shown, and if it cannot be loaded
/// (no internet, broken link) a placeholder takes its place, so the layout
/// never breaks.
class PostImage extends StatelessWidget {
  const PostImage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          semanticLabel: 'Post image',
          loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? progress,
          ) {
            if (progress == null) return child;
            return const _ImagePlaceholder(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stack) {
            return const _ImagePlaceholder(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text('Image unavailable', style: AppTextStyles.meta),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Center(child: child),
    );
  }
}
