import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/comment_tile.dart';
import '../widgets/empty_state.dart';
import '../widgets/post_card.dart';
import '../widgets/responsive_center.dart';

/// Wireframe 6 - Post Detail. The full post, its comments (replies are
/// indented) and a box to write a comment or a reply.
///
/// Own posts show Edit and Delete, other users' posts show Report.
class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();

  /// The comment the user is replying to, or null for a top-level comment.
  Comment? _replyTo;

  /// Last version of the post that was found. Keeps the screen filled while
  /// it slides away after the post was deleted.
  Post? _lastPost;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  void _startReply(Comment comment) {
    setState(() => _replyTo = comment);
    _commentFocus.requestFocus();
  }

  void _sendComment() {
    final String text = _commentController.text.trim();
    if (text.isEmpty) return;

    AppStateScope.read(context).addComment(
      postId: widget.postId,
      content: text,
      replyTo: _replyTo,
    );
    _commentController.clear();
    _commentFocus.unfocus();
    setState(() => _replyTo = null);
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    _lastPost = state.postById(widget.postId) ?? _lastPost;
    final Post? post = _lastPost;

    if (post == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Post')),
        body: const Center(
          child: EmptyState(
            icon: Icons.article_outlined,
            message: 'This post is no longer available.',
          ),
        ),
      );
    }

    final List<Comment> comments = state.commentsForPost(post.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: SafeArea(
        child: ResponsiveCenter(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: AppSpacing.screen,
                  children: <Widget>[
                    PostCard(
                      post: post,
                      expanded: true,
                      onEdit: () {
                        AppRoutes.openPostForm(context, editPostId: post.id);
                      },
                      onDeleted: () {
                        if (mounted) Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Comments (${comments.length})',
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (comments.isEmpty)
                      const EmptyState(
                        icon: Icons.chat_bubble_outline,
                        message: 'No comments yet. Be the first to comment.',
                      ),
                    for (final Comment comment in comments)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: CommentTile(
                          key: ValueKey<String>(comment.id),
                          comment: comment,
                          onReply: () => _startReply(comment),
                        ),
                      ),
                  ],
                ),
              ),
              _CommentComposer(
                controller: _commentController,
                focusNode: _commentFocus,
                replyingTo: _replyTo == null
                    ? null
                    : state.userById(_replyTo!.authorId).handle,
                onCancelReply: () => setState(() => _replyTo = null),
                onSend: _sendComment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Text box and Send button pinned to the bottom of the Post Detail screen.
class _CommentComposer extends StatelessWidget {
  const _CommentComposer({
    required this.controller,
    required this.focusNode,
    required this.replyingTo,
    required this.onCancelReply,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  /// Handle of the user being replied to, or null.
  final String? replyingTo;
  final VoidCallback onCancelReply;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (replyingTo != null)
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Replying to $replyingTo',
                    style: AppTextStyles.meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  tooltip: 'Cancel reply',
                  visualDensity: VisualDensity.compact,
                  onPressed: onCancelReply,
                ),
              ],
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  minLines: 1,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: replyingTo == null
                        ? 'Write a comment'
                        : 'Write a reply',
                    border: _pillBorder(AppColors.border),
                    enabledBorder: _pillBorder(AppColors.border),
                    focusedBorder: _pillBorder(AppColors.primary),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // The button is disabled while the text box is empty.
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (
                  BuildContext context,
                  TextEditingValue value,
                  Widget? child,
                ) {
                  return FilledButton(
                    style: FilledButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    onPressed: value.text.trim().isEmpty ? null : onSend,
                    child: const Text('Send'),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  static OutlineInputBorder _pillBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      borderSide: BorderSide(color: color),
    );
  }
}
