/// A post inside a community.
class Post {
  const Post({
    required this.id,
    required this.communityId,
    required this.authorId,
    required this.title,
    required this.content,
    required this.createdAt,
    this.imageUrl,
    this.votes = 0,
    this.userVote = 0,
  });

  final String id;
  final String communityId;
  final String authorId;
  final String title;
  final String content;
  final DateTime createdAt;

  /// Optional image attached to the post (loaded from the network).
  final String? imageUrl;

  /// Votes from other users (placeholder data).
  final int votes;

  /// The current user's vote: 1 = upvote, -1 = downvote, 0 = no vote.
  final int userVote;

  /// Number shown between the vote arrows.
  int get score => votes + userVote;

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Returns a copy with some fields replaced. Pass [removeImage] to clear
  /// the image, because `imageUrl: null` means "keep the current one".
  Post copyWith({
    String? communityId,
    String? title,
    String? content,
    String? imageUrl,
    bool removeImage = false,
    int? userVote,
  }) {
    return Post(
      id: id,
      communityId: communityId ?? this.communityId,
      authorId: authorId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      imageUrl: removeImage ? null : (imageUrl ?? this.imageUrl),
      votes: votes,
      userVote: userVote ?? this.userVote,
    );
  }
}
