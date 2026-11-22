import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sutory/app.dart';
import 'package:sutory/widgets/post_card.dart';

/// Starts the app on a phone-sized screen.
Future<void> pumpApp(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const SutoryApp());
  await tester.pumpAndSettle();
}

/// Fills the login form with valid values and opens the Home Feed.
Future<void> logIn(WidgetTester tester) async {
  await tester.enterText(
    find.byType(TextFormField).at(0),
    'student@sabanciuniv.edu',
  );
  await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
  await tester.tap(find.text('Log In'));
  await tester.pumpAndSettle();
}

/// Scrolls [finder] into view, taps it and waits for animations.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('login shows inline errors, then opens the Home Feed', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    expect(find.text('University email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'me@gmail.com');
    await tester.pumpAndSettle();
    expect(find.text('Must end with @sabanciuniv.edu'), findsOneWidget);

    await logIn(tester);
    expect(find.byType(PostCard), findsWidgets);
    expect(find.text('Anyone selling a used calculator?'), findsOneWidget);
  });

  testWidgets('sign up validates fields and confirms with a dialog', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text("Don't have an account? Sign up"));
    await tester.pumpAndSettle();
    expect(find.text('Create Account'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'ab');
    await tester.enterText(find.byType(TextFormField).at(1), 'ab@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123456');
    await tester.enterText(find.byType(TextFormField).at(3), '654321');
    await tapVisible(tester, find.text('Sign Up'));
    expect(find.text('Username must be at least 3 characters'), findsOneWidget);
    expect(find.text('Must end with @sabanciuniv.edu'), findsOneWidget);
    expect(find.text('Passwords do not match'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'new_student');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'new.student@sabanciuniv.edu',
    );
    await tester.enterText(find.byType(TextFormField).at(3), '123456');
    await tapVisible(tester, find.text('Sign Up'));
    expect(find.text('Account created'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(PostCard), findsWidgets);
  });

  testWidgets('bottom navigation switches between the four tabs', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await logIn(tester);

    await tester.tap(find.byIcon(Icons.groups_outlined));
    await tester.pumpAndSettle();
    expect(find.text('su/Courses'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(find.text('Search posts or communities'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.text('@night_owl'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
  });

  testWidgets('create post: inline errors, confirmation, new card on Home', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await logIn(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('New Post'), findsOneWidget);

    await tapVisible(tester, find.text('Post'));
    expect(find.text('Please choose a community'), findsOneWidget);
    expect(find.text('Title is required'), findsOneWidget);
    expect(find.text('Content is required'), findsOneWidget);

    await tapVisible(tester, find.text('Choose a community'));
    await tester.tap(find.text('su/Dorms').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Widget test post',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'This post was written by a widget test.',
    );
    await tapVisible(tester, find.text('Post'));
    expect(find.text('Post published'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Widget test post'), findsOneWidget);
  });

  testWidgets('delete asks for confirmation and removes the card', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await logIn(tester);
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.text('Selling my CS201 textbook'), findsOneWidget);
    await tapVisible(tester, find.text('Delete').first);
    expect(find.text('Delete post?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Selling my CS201 textbook'), findsNothing);
    expect(find.text('Post deleted'), findsOneWidget);
  });

  testWidgets('report needs a reason and then confirms', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await logIn(tester);

    await tapVisible(tester, find.text('Report').first);
    expect(find.text('Report post'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Report'));
    await tester.pumpAndSettle();
    expect(find.text('Please select a reason'), findsOneWidget);

    await tester.tap(find.text('Other'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Report'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Report submitted'), findsOneWidget);
  });

  // Walks through every screen and dialog. A RenderFlex overflow is reported
  // as an exception, which makes the test fail.
  for (final Size size in const <Size>[
    Size(320, 568), // small phone
    Size(360, 640), // compact Android phone
    Size(430, 932), // large phone
  ]) {
    testWidgets(
        'no overflow on a ${size.width.toInt()}x'
        '${size.height.toInt()} screen', (WidgetTester tester) async {
      await pumpApp(tester, size: size);

      // Sign Up and back.
      await tapVisible(tester, find.text("Don't have an account? Sign up"));
      await tapVisible(tester, find.text('Sign Up'));
      await tester.pageBack();
      await tester.pumpAndSettle();
      await logIn(tester);

      // Home Feed -> Post Detail -> Report dialog.
      await tester.tap(find.text('Anyone selling a used calculator?'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Comments ('), findsOneWidget);
      await tapVisible(tester, find.text('Report').first);
      await tester.tap(find.text('Other'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Create Post form with validation errors.
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tapVisible(tester, find.text('Post'));
      await tapVisible(tester, find.text('Add image'));
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Communities -> Community Page.
      await tester.tap(find.byIcon(Icons.groups_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('su/Courses'));
      await tester.pumpAndSettle();
      expect(find.text('Course questions and discussions · 1.2k members'),
          findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Search.
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'cs310');
      await tester.pumpAndSettle();

      // Profile -> Comments tab -> Delete dialog.
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      await tapVisible(tester, find.textContaining('Comments ('));
      await tapVisible(tester, find.textContaining('Posts ('));
      await tapVisible(tester, find.text('Delete').first);
      expect(find.text('Delete post?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
    });
  }
}
