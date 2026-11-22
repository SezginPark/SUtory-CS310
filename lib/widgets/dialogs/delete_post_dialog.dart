import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../state/app_state.dart';
import '../../state/app_state_scope.dart';
import '../app_buttons.dart';

/// Asks the user to confirm deleting one of their own posts.
class DeletePostDialog extends StatelessWidget {
  const DeletePostDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Delete post?', textAlign: TextAlign.center),
      content: const Text(
        'This post and its comments will be removed. '
        "This can't be undone.",
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        SecondaryButton(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(false),
        ),
        PillFilledButton(
          label: 'Delete',
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

/// Opens the delete dialog and, if the user confirms, removes [post] from
/// the shared state and shows a confirmation message.
///
/// Returns true when the post was deleted.
Future<bool> confirmAndDeletePost(BuildContext context, Post post) async {
  final AppState state = AppStateScope.read(context);
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

  final bool confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) => const DeletePostDialog(),
      ) ??
      false;
  if (!confirmed) return false;

  state.deletePost(post.id);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(const SnackBar(content: Text('Post deleted')));
  return true;
}
