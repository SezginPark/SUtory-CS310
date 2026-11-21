import 'package:flutter/foundation.dart';

import '../data/sample_data.dart';
import '../models/app_user.dart';
import '../models/comment.dart';
import '../models/community.dart';
import '../models/post.dart';

/// How a list of posts is ordered.
enum PostSort {
  newest('New'),
  voteCount('Vote Count');

  const PostSort(this.label);
  final String label;
}

/// What the search screen shows.
enum SearchFilter {
  all('All'),
  posts('Posts'),
  communities('Communities');

  const SearchFilter(this.label);
  final String label;
}

/// The single source of truth for the UI while the app runs on placeholder
/// data. It keeps everything in memory, so changes stay visible across
/// screens until the app is restarted. Widgets read it through
/// `AppStateScope.of(context)` and rebuild when [notifyListeners] is called.
class AppState extends ChangeNotifier {
  AppState({DateTime? now}) {
    final DateTime start = now ?? DateTime.now();
    _users = SampleData.users();
    _communities = SampleData.communities();
    _posts = SampleData.posts(start);
    _comments = SampleData.comments(start);
  }

  late List<AppUser> _users;
  late List<Community> _communities;
  late List<Post> _posts;
  late List<Comment> _comments;

  int _tabIndex = 0;
  int _nextId = 1;

  // ---------------------------------------------------------------- tabs

  /// Selected tab of the bottom navigation bar
  /// (0 Home, 1 Communities, 2 Search, 3 Profile).
  int get tabIndex => _tabIndex;

  void selectTab(int index) {
    if (index == _tabIndex) return;
    _tabIndex = index;
    notifyListeners();
  }

  // --------------------------------------------------------------- users

  AppUser get currentUser => userById(SampleData.currentUserId);

  AppUser userById(String id) {
    return _users.firstWhere(
      (AppUser user) => user.id == id,
      orElse: () => AppUser(
        id: id,
        username: 'deleted_user',
        email: '',
        joinedAt: DateTime(2026),
      ),
    );
  }

  /// Called from the sign-up form. Authentication is UI-only in Step 2.2,
  /// so this only renames the placeholder user.
  void updateProfile({required String username, required String email}) {
    _users = <AppUser>[
      for (final AppUser user in _users)
        if (user.id == SampleData.currentUserId)
          user.copyWith(username: username, email: email)
        else
          user,
    ];
    notifyListeners();
  }

  // --------------------------------------------------------- communities

  List<Community> get communities => List<Community>.unmodifiable(_communities);

  Community? communityById(String id) {
    for (final Community community in _communities) {
      if (community.id == id) return community;
    }
    return null;
  }

  /// Joins the community, or leaves it if the user already joined.
  void toggleJoin(String communityId) {
    _communities = <Community>[
      for (final Community community in _communities)
        if (community.id == communityId)
          community.copyWith(
            isJoined: !community.isJoined,
            memberCount: community.memberCount + (community.isJoined ? -1 : 1),
          )
        else
          community,
    ];
    notifyListeners();
  }

  // --------------------------------------------------------------- posts

  /// Posts of one community, or of all communities when [communityId] is
  /// null, ordered by [sort].
  List<Post> posts({String? communityId, PostSort sort = PostSort.newest}) {
    final List<Post> result = <Post>[
      for (final Post post in _posts)
        if (communityId == null || post.communityId == communityId) post,
    ];
    _sortPosts(result, sort);
    return result;
  }

  Post? postById(String id) {
    for (final Post post in _posts) {
      if (post.id == id) return post;
    }
    return null;
  }

  bool isOwnPost(Post post) => post.authorId == SampleData.currentUserId;

  /// Posts written by the current user, newest first.
  List<Post> get myPosts {
    final List<Post> result = <Post>[
      for (final Post post in _posts)
        if (isOwnPost(post)) post,
    ];
    _sortPosts(result, PostSort.newest);
    return result;
  }

  Post addPost({
    required String communityId,
    required String title,
    required String content,
    String? imageUrl,
  }) {
    final Post post = Post(
      id: 'p_new_${_nextId++}',
      communityId: communityId,
      authorId: SampleData.currentUserId,
      title: title.trim(),
      content: content.trim(),
      createdAt: DateTime.now(),
      imageUrl: imageUrl,
    );
    _posts = <Post>[post, ..._posts];
    notifyListeners();
    return post;
  }

  void updatePost(
    String postId, {
    required String communityId,
    required String title,
    required String content,
    String? imageUrl,
  }) {
    _posts = <Post>[
      for (final Post post in _posts)
        if (post.id == postId)
          post.copyWith(
            communityId: communityId,
            title: title.trim(),
            content: content.trim(),
            imageUrl: imageUrl,
            removeImage: imageUrl == null,
          )
        else
          post,
    ];
    notifyListeners();
  }

  /// Removes the post and all of its comments.
  void deletePost(String postId) {
    _posts = <Post>[
      for (final Post post in _posts)
        if (post.id != postId) post,
    ];
    _comments = <Comment>[
      for (final Comment comment in _comments)
        if (comment.postId != postId) comment,
    ];
    notifyListeners();
  }

  /// [direction] is 1 for the up arrow and -1 for the down arrow.
  /// Tapping the same arrow again removes the vote.
  void votePost(String postId, int direction) {
    _posts = <Post>[
      for (final Post post in _posts)
        if (post.id == postId)
          post.copyWith(userVote: post.userVote == direction ? 0 : direction)
        else
          post,
    ];
    notifyListeners();
  }

  // ------------------------------------------------------------ comments

  /// Comments of a post in display order: every top-level comment is
  /// followed by its replies, both oldest first.
  List<Comment> commentsForPost(String postId) {
    final List<Comment> all = <Comment>[
      for (final Comment comment in _comments)
        if (comment.postId == postId) comment,
    ]..sort((Comment a, Comment b) => a.createdAt.compareTo(b.createdAt));

    final List<Comment> ordered = <Comment>[];
    for (final Comment comment in all) {
      if (comment.isReply) continue;
      ordered.add(comment);
      ordered.addAll(
        all.where((Comment reply) => reply.parentId == comment.id),
      );
    }
    return ordered;
  }

  int commentCount(String postId) {
    return _comments.where((Comment c) => c.postId == postId).length;
  }

  /// Comments written by the current user, newest first.
  List<Comment> get myComments {
    return <Comment>[
      for (final Comment comment in _comments)
        if (comment.authorId == SampleData.currentUserId) comment,
    ]..sort((Comment a, Comment b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Adds a comment by the current user. When [replyTo] is given the new
  /// comment is shown as a reply. Replies stay one level deep, so replying
  /// to a reply attaches the comment to the same parent.
  void addComment({
    required String postId,
    required String content,
    Comment? replyTo,
  }) {
    final Comment comment = Comment(
      id: 'cm_new_${_nextId++}',
      postId: postId,
      authorId: SampleData.currentUserId,
      content: content.trim(),
      createdAt: DateTime.now(),
      parentId: replyTo == null ? null : (replyTo.parentId ?? replyTo.id),
    );
    _comments = <Comment>[..._comments, comment];
    notifyListeners();
  }

  void voteComment(String commentId, int direction) {
    _comments = <Comment>[
      for (final Comment comment in _comments)
        if (comment.id == commentId)
          comment.copyWith(
            userVote: comment.userVote == direction ? 0 : direction,
          )
        else
          comment,
    ];
    notifyListeners();
  }

  // -------------------------------------------------------------- search

  /// Posts whose title, content, community or author matches [query].
  /// An empty query returns every post, newest first.
  List<Post> searchPosts(String query) {
    final String q = query.trim().toLowerCase();
    final List<Post> result = <Post>[
      for (final Post post in _posts)
        if (q.isEmpty || _postMatches(post, q)) post,
    ];
    _sortPosts(result, PostSort.newest);
    return result;
  }

  /// Communities whose name or description matches [query].
  List<Community> searchCommunities(String query) {
    final String q = query.trim().toLowerCase();
    return <Community>[
      for (final Community community in _communities)
        if (q.isEmpty ||
            community.displayName.toLowerCase().contains(q) ||
            community.description.toLowerCase().contains(q))
          community,
    ];
  }

  bool _postMatches(Post post, String q) {
    final String community = communityById(post.communityId)?.displayName ?? '';
    final String author = userById(post.authorId).username;
    return post.title.toLowerCase().contains(q) ||
        post.content.toLowerCase().contains(q) ||
        community.toLowerCase().contains(q) ||
        author.toLowerCase().contains(q);
  }

  void _sortPosts(List<Post> list, PostSort sort) {
    switch (sort) {
      case PostSort.newest:
        list.sort((Post a, Post b) => b.createdAt.compareTo(a.createdAt));
      case PostSort.voteCount:
        list.sort((Post a, Post b) {
          final int byScore = b.score.compareTo(a.score);
          return byScore != 0 ? byScore : b.createdAt.compareTo(a.createdAt);
        });
    }
  }
}
