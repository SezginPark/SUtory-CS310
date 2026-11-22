import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../data/sample_data.dart';
import '../models/community.dart';
import '../models/post.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/validators.dart';
import '../widgets/app_buttons.dart';
import '../widgets/dialogs/confirmation_dialog.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/post_image.dart';
import '../widgets/responsive_center.dart';

/// Wireframe 7 - Create / Edit Post. A form with community, title, content
/// and an optional image. Invalid fields show inline errors; a valid
/// submission shows a confirmation dialog.
///
/// New post -> back to the Home Feed. Edited post -> back to Post Detail.
class PostFormScreen extends StatefulWidget {
  const PostFormScreen({super.key, this.initialCommunityId, this.editPostId});

  /// Community selected when the form opens (from a Community Page).
  final String? initialCommunityId;

  /// Id of the post to edit, or null to create a new post.
  final String? editPostId;

  bool get isEditing => editPostId != null;

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  String? _communityId;
  String? _imageUrl;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    // Pre-fill the form: with the post when editing, or with the community
    // the user came from when creating.
    final AppState state = AppStateScope.read(context);
    final Post? post =
        widget.isEditing ? state.postById(widget.editPostId!) : null;
    if (post != null) {
      _communityId = post.communityId;
      _titleController.text = post.title;
      _contentController.text = post.content;
      _imageUrl = post.imageUrl;
    } else {
      _communityId = widget.initialCommunityId;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Step 2.2 has no image picker yet, so this attaches a sample photo.
  void _attachSampleImage() {
    final int postCount = AppStateScope.read(context).posts().length;
    final List<String> images = SampleData.attachableImages;
    setState(() => _imageUrl = images[postCount % images.length]);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      return;
    }

    final AppState state = AppStateScope.read(context);
    final NavigatorState navigator = Navigator.of(context);
    final String communityId = _communityId!;
    final String communityName =
        state.communityById(communityId)?.displayName ?? 'the community';
    FocusScope.of(context).unfocus();

    if (widget.isEditing) {
      state.updatePost(
        widget.editPostId!,
        communityId: communityId,
        title: _titleController.text,
        content: _contentController.text,
        imageUrl: _imageUrl,
      );
      await showConfirmationDialog(
        context,
        title: 'Post updated',
        message: 'Your changes have been saved.',
      );
      // Back to Post Detail, which now shows the updated content.
      navigator.pop();
    } else {
      state.addPost(
        communityId: communityId,
        title: _titleController.text,
        content: _contentController.text,
        imageUrl: _imageUrl,
      );
      await showConfirmationDialog(
        context,
        title: 'Post published',
        message: 'Your post is now live in $communityName.',
      );
      // Back to the Home Feed, where the new post is at the top.
      state.selectTab(0);
      navigator.popUntil(ModalRoute.withName(AppRoutes.main));
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final List<Community> communities = state.communities;

    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit Post' : 'New Post')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screen,
          child: ResponsiveCenter(
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text('Community', style: AppTextStyles.label),
                  const SizedBox(height: AppSpacing.xs),
                  _CommunityField(
                    communities: communities,
                    initialValue: _communityId,
                    onChanged: (String? id) => _communityId = id,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  LabeledTextField(
                    label: 'Title',
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    validator: Validators.postTitle,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  LabeledTextField(
                    label: 'Content',
                    controller: _contentController,
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: 10,
                    validator: Validators.postContent,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (_imageUrl == null)
                    _AddImageButton(onTap: _attachSampleImage)
                  else
                    _AttachedImage(
                      url: _imageUrl!,
                      onRemove: () => setState(() => _imageUrl = null),
                    ),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(
                    label: widget.isEditing ? 'Save changes' : 'Post',
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dropdown for choosing the community, wrapped in a [FormField] so it is
/// validated together with the text fields and shows its error inline.
class _CommunityField extends StatelessWidget {
  const _CommunityField({
    required this.communities,
    required this.initialValue,
    required this.onChanged,
  });

  final List<Community> communities;
  final String? initialValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: initialValue,
      validator: (String? value) {
        return value == null ? 'Please choose a community' : null;
      },
      builder: (FormFieldState<String> field) {
        return InputDecorator(
          decoration: InputDecoration(
            errorText: field.errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: field.value,
              isExpanded: true,
              dropdownColor: AppColors.surface,
              style: AppTextStyles.body,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: AppColors.textPrimary,
              ),
              hint: const Text(
                'Choose a community',
                style: AppTextStyles.bodyMuted,
              ),
              items: <DropdownMenuItem<String>>[
                for (final Community community in communities)
                  DropdownMenuItem<String>(
                    value: community.id,
                    child: Text(
                      community.displayName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (String? id) {
                field.didChange(id);
                onChanged(id);
              },
            ),
          ),
        );
      },
    );
  }
}

/// The "+ Add image" box shown while the post has no image.
class _AddImageButton extends StatelessWidget {
  const _AddImageButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(AppRadius.sm);
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add_photo_alternate_outlined, size: 20),
                  SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text('Add image', style: AppTextStyles.label),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Attaches a sample photo for now',
                style: AppTextStyles.meta,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Preview of the attached image with a button to remove it.
class _AttachedImage extends StatelessWidget {
  const _AttachedImage({required this.url, required this.onRemove});

  final String url;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PostImage(url: url),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Remove image'),
          ),
        ),
      ],
    );
  }
}
