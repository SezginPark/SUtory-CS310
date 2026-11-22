import '../models/app_user.dart';
import '../models/comment.dart';
import '../models/community.dart';
import '../models/post.dart';

/// Placeholder data used in Step 2.2 instead of a backend.
/// Firebase will replace this in Step 3.
class SampleData {
  SampleData._();

  /// Id of the user who is "logged in" while the app uses placeholder data.
  static const String currentUserId = 'u_night_owl';

  /// Images that "+ Add image" attaches in the Create / Edit Post form.
  /// A real image picker comes with the backend in Step 3.
  static const List<String> attachableImages = <String>[
    'https://picsum.photos/seed/sutory-campus/800/450',
    'https://picsum.photos/seed/sutory-library/800/450',
    'https://picsum.photos/seed/sutory-desk/800/450',
  ];

  static List<AppUser> users() {
    return <AppUser>[
      AppUser(
        id: currentUserId,
        username: 'night_owl',
        email: 'night.owl@sabanciuniv.edu',
        joinedAt: DateTime(2026, 10, 5),
        karma: 128,
      ),
      AppUser(
        id: 'u_calc_dealer',
        username: 'calc_dealer',
        email: 'calc.dealer@sabanciuniv.edu',
        joinedAt: DateTime(2026, 9, 21),
        karma: 54,
      ),
      AppUser(
        id: 'u_midterm_ghost',
        username: 'midterm_ghost',
        email: 'midterm.ghost@sabanciuniv.edu',
        joinedAt: DateTime(2026, 9, 18),
        karma: 311,
      ),
      AppUser(
        id: 'u_lostinlib',
        username: 'lostinlib',
        email: 'lostinlib@sabanciuniv.edu',
        joinedAt: DateTime(2026, 9, 30),
        karma: 87,
      ),
      AppUser(
        id: 'u_coffee_addict',
        username: 'coffee_addict',
        email: 'coffee.addict@sabanciuniv.edu',
        joinedAt: DateTime(2026, 10, 2),
        karma: 203,
      ),
      AppUser(
        id: 'u_dormlord',
        username: 'dormlord',
        email: 'dormlord@sabanciuniv.edu',
        joinedAt: DateTime(2026, 10, 11),
        karma: 42,
      ),
      AppUser(
        id: 'u_tea_enjoyer',
        username: 'tea_enjoyer',
        email: 'tea.enjoyer@sabanciuniv.edu',
        joinedAt: DateTime(2026, 10, 14),
        karma: 96,
      ),
    ];
  }

  static List<Community> communities() {
    return const <Community>[
      Community(
        id: 'c_courses',
        name: 'Courses',
        description: 'Course questions and discussions',
        memberCount: 1200,
        isJoined: true,
      ),
      Community(
        id: 'c_dorms',
        name: 'Dorms',
        description: 'Dorm life, roommates and maintenance',
        memberCount: 640,
        isJoined: true,
      ),
      Community(
        id: 'c_events',
        name: 'Events',
        description: 'Concerts, club events and campus announcements',
        memberCount: 910,
      ),
      Community(
        id: 'c_lost_found',
        name: 'Lost & Found',
        description: 'Lost something on campus? Found something? Post it here',
        memberCount: 430,
      ),
      Community(
        id: 'c_marketplace',
        name: 'Marketplace',
        description: 'Buy and sell second-hand items with other students',
        memberCount: 780,
      ),
    ];
  }

  static List<Post> posts(DateTime now) {
    DateTime ago({int hours = 0, int minutes = 0}) {
      return now.subtract(Duration(hours: hours, minutes: minutes));
    }

    return <Post>[
      Post(
        id: 'p_calculator',
        communityId: 'c_marketplace',
        authorId: 'u_calc_dealer',
        title: 'Anyone selling a used calculator?',
        content: 'I need a scientific calculator for the MATH201 final. '
            'A Casio fx-991 or something similar would be perfect. '
            'I can pick it up anywhere on campus.',
        createdAt: ago(hours: 1),
        votes: 12,
      ),
      Post(
        id: 'p_concert',
        communityId: 'c_events',
        authorId: 'u_tea_enjoyer',
        title: 'Free concert tonight?',
        content: 'I heard there is a free concert at the amphitheatre tonight '
            'at 20:00. Does anyone know who is playing and whether we '
            'need to register first?',
        createdAt: ago(hours: 1, minutes: 20),
        votes: 12,
      ),
      Post(
        id: 'p_resources',
        communityId: 'c_courses',
        authorId: 'u_lostinlib',
        title: 'Best CS310 resources?',
        content: 'Which resources helped you the most with Flutter layouts and '
            'navigation? Lecture slides are fine, but I am looking for '
            'extra practice material.',
        createdAt: ago(hours: 2),
        votes: 12,
      ),
      Post(
        id: 'p_step2',
        communityId: 'c_courses',
        authorId: 'u_midterm_ghost',
        title: 'CS310 Step 2 questions',
        content: 'Our group is working on the UI implementation step. Do we '
            'really need a custom font and both local and network images? '
            'Sharing my desk setup for motivation.',
        createdAt: ago(hours: 3),
        imageUrl: 'https://picsum.photos/seed/sutory-cs310/800/450',
        votes: 24,
      ),
      Post(
        id: 'p_textbook',
        communityId: 'c_marketplace',
        authorId: currentUserId,
        title: 'Selling my CS201 textbook',
        content: 'Barely used and no highlighting. Half the bookstore price. '
            'I am usually around FENS in the afternoons.',
        createdAt: ago(hours: 4),
        imageUrl: 'https://picsum.photos/seed/sutory-books/800/450',
        votes: 9,
      ),
      Post(
        id: 'p_laundry',
        communityId: 'c_dorms',
        authorId: currentUserId,
        title: 'Dorm laundry broken again',
        content: 'Two of the three washing machines in B8 are out of order '
            'again. Has anyone already reported it to the dorm office?',
        createdAt: ago(hours: 5),
        votes: 7,
      ),
      Post(
        id: 'p_midterm_tips',
        communityId: 'c_courses',
        authorId: 'u_coffee_addict',
        title: 'MATH201 midterm tips',
        content: 'Solve the last three years of past exams and focus on the '
            'eigenvalue questions. The recitation problems are very close '
            'to what shows up in the exam.',
        createdAt: ago(hours: 6),
        votes: 15,
      ),
      Post(
        id: 'p_umbrella',
        communityId: 'c_lost_found',
        authorId: 'u_dormlord',
        title: 'Lost: black umbrella near FASS',
        content: 'I left a black umbrella with a wooden handle in front of '
            'FASS G022 yesterday evening. Please message me if you saw it.',
        createdAt: ago(hours: 9),
        votes: 3,
      ),
    ];
  }

  static List<Comment> comments(DateTime now) {
    DateTime ago({int hours = 0, int minutes = 0}) {
      return now.subtract(Duration(hours: hours, minutes: minutes));
    }

    return <Comment>[
      // CS310 Step 2 questions
      Comment(
        id: 'cm_1',
        postId: 'p_step2',
        authorId: 'u_lostinlib',
        content: 'Yes, both are in the guideline. A logo works for the local '
            'image and any post photo for the network one.',
        createdAt: ago(hours: 2),
        votes: 5,
      ),
      Comment(
        id: 'cm_2',
        postId: 'p_step2',
        authorId: 'u_coffee_addict',
        content: 'Also do not forget the remove action on the card list.',
        createdAt: ago(hours: 1),
        parentId: 'cm_1',
        votes: 2,
      ),
      Comment(
        id: 'cm_3',
        postId: 'p_step2',
        authorId: 'u_dormlord',
        content: 'Thanks for asking, our group had the same question.',
        createdAt: ago(minutes: 40),
        votes: 1,
      ),
      // Anyone selling a used calculator?
      Comment(
        id: 'cm_4',
        postId: 'p_calculator',
        authorId: currentUserId,
        content: 'I have a spare fx-82. Not the 991, but it is yours for free.',
        createdAt: ago(minutes: 35),
        votes: 4,
      ),
      Comment(
        id: 'cm_5',
        postId: 'p_calculator',
        authorId: 'u_calc_dealer',
        content: 'That would work, thank you! I will message you.',
        createdAt: ago(minutes: 20),
        parentId: 'cm_4',
        votes: 1,
      ),
      // Dorm laundry broken again
      Comment(
        id: 'cm_6',
        postId: 'p_laundry',
        authorId: 'u_dormlord',
        content: 'Reported it this morning. They said a technician is coming.',
        createdAt: ago(hours: 3),
        votes: 6,
      ),
      Comment(
        id: 'cm_7',
        postId: 'p_laundry',
        authorId: 'u_tea_enjoyer',
        content: 'The machines in B10 are working if you need them today.',
        createdAt: ago(hours: 2),
        votes: 3,
      ),
      // Best CS310 resources?
      Comment(
        id: 'cm_8',
        postId: 'p_resources',
        authorId: currentUserId,
        content: 'The official Flutter codelabs are great for layouts. Start '
            'with the "Basic Flutter layout" one.',
        createdAt: ago(hours: 1, minutes: 30),
        votes: 8,
      ),
      // Free concert tonight?
      Comment(
        id: 'cm_9',
        postId: 'p_concert',
        authorId: 'u_midterm_ghost',
        content: 'It is the music club. No registration, just show up early.',
        createdAt: ago(minutes: 50),
        votes: 7,
      ),
      // MATH201 midterm tips
      Comment(
        id: 'cm_10',
        postId: 'p_midterm_tips',
        authorId: 'u_lostinlib',
        content: 'Where can I find the past exams?',
        createdAt: ago(hours: 5),
        votes: 2,
      ),
      Comment(
        id: 'cm_11',
        postId: 'p_midterm_tips',
        authorId: 'u_coffee_addict',
        content: 'They are in the course folder on SUCourse.',
        createdAt: ago(hours: 4, minutes: 30),
        parentId: 'cm_10',
        votes: 3,
      ),
    ];
  }
}
