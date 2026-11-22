import 'package:flutter_test/flutter_test.dart';
import 'package:sutory/models/comment.dart';
import 'package:sutory/models/post.dart';
import 'package:sutory/state/app_state.dart';
import 'package:sutory/utils/formatters.dart';
import 'package:sutory/utils/validators.dart';

void main() {
  final DateTime now = DateTime(2026, 11, 12, 12);
  late AppState state;

  setUp(() => state = AppState(now: now));

  group('posts', () {
    test('sample posts are sorted newest first by default', () {
      final List<Post> posts = state.posts();
      expect(posts, hasLength(8));
      expect(posts.first.title, 'Anyone selling a used calculator?');
      for (int i = 1; i < posts.length; i++) {
        expect(posts[i - 1].createdAt.isBefore(posts[i].createdAt), isFalse);
      }
    });

    test('sorting by vote count puts the highest score first', () {
      final List<Post> posts = state.posts(sort: PostSort.voteCount);
      expect(posts.first.title, 'CS310 Step 2 questions');
      for (int i = 1; i < posts.length; i++) {
        expect(posts[i - 1].score, greaterThanOrEqualTo(posts[i].score));
      }
    });

    test('posts can be filtered by community', () {
      expect(state.posts(communityId: 'c_courses'), hasLength(3));
      expect(state.posts(communityId: 'c_events'), hasLength(1));
    });

    test('voting toggles and switches direction', () {
      state.votePost('p_step2', 1);
      expect(state.postById('p_step2')!.score, 25);
      state.votePost('p_step2', 1);
      expect(state.postById('p_step2')!.score, 24);
      state.votePost('p_step2', -1);
      expect(state.postById('p_step2')!.score, 23);
      state.votePost('p_step2', 1);
      expect(state.postById('p_step2')!.score, 25);
    });

    test('a new post belongs to the current user and is on top', () {
      final Post created = state.addPost(
        communityId: 'c_dorms',
        title: ' New title ',
        content: ' Body text here ',
      );
      expect(state.posts().first.id, created.id);
      expect(created.title, 'New title');
      expect(state.isOwnPost(created), isTrue);
      expect(state.myPosts, hasLength(3));
    });

    test('editing a post changes its fields and can remove the image', () {
      state.updatePost(
        'p_textbook',
        communityId: 'c_events',
        title: 'Edited',
        content: 'Edited body text',
      );
      final Post edited = state.postById('p_textbook')!;
      expect(edited.title, 'Edited');
      expect(edited.communityId, 'c_events');
      expect(edited.hasImage, isFalse);
    });

    test('deleting a post also removes its comments', () {
      state.deletePost('p_step2');
      expect(state.postById('p_step2'), isNull);
      expect(state.commentCount('p_step2'), 0);
      expect(state.posts(), hasLength(7));
    });
  });

  group('comments', () {
    test('replies are listed right after their parent comment', () {
      final List<Comment> thread = state.commentsForPost('p_step2');
      expect(thread.map((Comment c) => c.id), <String>['cm_1', 'cm_2', 'cm_3']);
      expect(thread[1].isReply, isTrue);
    });

    test('a reply to a reply stays one level deep', () {
      final Comment reply = state.commentsForPost('p_step2')[1];
      state.addComment(postId: 'p_step2', content: 'Nested', replyTo: reply);
      final List<Comment> thread = state.commentsForPost('p_step2');
      expect(thread[2].content, 'Nested');
      expect(thread[2].parentId, 'cm_1');
    });

    test('a new top-level comment is added at the end', () {
      state.addComment(postId: 'p_step2', content: '  Hello  ');
      expect(state.commentsForPost('p_step2').last.content, 'Hello');
      expect(state.commentCount('p_step2'), 4);
    });
  });

  group('communities and search', () {
    test('join toggles the flag and the member count', () {
      state.toggleJoin('c_events');
      expect(state.communityById('c_events')!.isJoined, isTrue);
      expect(state.communityById('c_events')!.memberCount, 911);
      state.toggleJoin('c_events');
      expect(state.communityById('c_events')!.isJoined, isFalse);
      expect(state.communityById('c_events')!.memberCount, 910);
    });

    test('search matches title, community and author', () {
      expect(state.searchPosts('calculator'), hasLength(1));
      expect(state.searchPosts('MARKETPLACE'), hasLength(2));
      expect(state.searchPosts('coffee_addict'), hasLength(1));
      expect(state.searchPosts('zzzz'), isEmpty);
      expect(state.searchCommunities('lost').single.name, 'Lost & Found');
    });

    test('an empty query returns everything', () {
      expect(state.searchPosts(''), hasLength(8));
      expect(state.searchCommunities('  '), hasLength(5));
    });
  });

  group('validators', () {
    test('university email must end with @sabanciuniv.edu', () {
      expect(Validators.universityEmail('ali@sabanciuniv.edu'), isNull);
      expect(Validators.universityEmail(' Ali@SabanciUniv.edu '), isNull);
      expect(
        Validators.universityEmail('ali@gmail.com'),
        'Must end with @sabanciuniv.edu',
      );
      expect(Validators.universityEmail('@sabanciuniv.edu'), isNotNull);
      expect(Validators.universityEmail(''), 'University email is required');
    });

    test('password rules', () {
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password('123456'), isNull);
      expect(Validators.confirmPassword('a', 'b'), 'Passwords do not match');
      expect(Validators.confirmPassword('abc', 'abc'), isNull);
    });

    test('post title and content rules', () {
      expect(Validators.postTitle(''), 'Title is required');
      expect(Validators.postTitle('Hello world'), isNull);
      expect(Validators.postContent('short'), isNotNull);
      expect(Validators.postContent('long enough text'), isNull);
    });
  });

  group('formatters', () {
    test('compact counts', () {
      expect(Formatters.compactCount(640), '640');
      expect(Formatters.compactCount(1200), '1.2k');
      expect(Formatters.compactCount(1000), '1k');
    });

    test('relative time', () {
      DateTime ago(Duration d) => now.subtract(d);
      expect(Formatters.timeAgo(ago(const Duration(minutes: 40)), now: now),
          '40m');
      expect(Formatters.timeAgo(ago(const Duration(hours: 3)), now: now), '3h');
      expect(Formatters.timeAgo(ago(const Duration(days: 2)), now: now), '2d');
    });
  });
}
