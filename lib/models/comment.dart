/// A comment under a post. A comment with a [parentId] is a reply and is
/// shown indented under its parent comment.
class Comment {
  const Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    this.parentId,
    this.votes = 0,
    this.userVote = 0,
  });

  final String id;
  final String postId;
  final String authorId;
  final String content;
  final DateTime createdAt;

  /// Id of the comment this one replies to, or null for a top-level comment.
  final String? parentId;

  /// Votes from other users (placeholder data).
  final int votes;

  /// The current user's vote: 1 = upvote, -1 = downvote, 0 = no vote.
  final int userVote;

  int get score => votes + userVote;

  bool get isReply => parentId != null;

  Comment copyWith({int? userVote}) {
    return Comment(
      id: id,
      postId: postId,
      authorId: authorId,
      content: content,
      createdAt: createdAt,
      parentId: parentId,
      votes: votes,
      userVote: userVote ?? this.userVote,
    );
  }
}
