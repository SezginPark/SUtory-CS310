import 'package:flutter/material.dart';

import 'screens/community_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'screens/post_detail_screen.dart';
import 'screens/post_form_screen.dart';
import 'screens/signup_screen.dart';

/// All navigation of the app in one place.
///
/// The three top-level screens are named routes. Screens that need an
/// argument (a post or a community) are opened with the helper methods.
class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String signUp = '/signup';

  /// The main app: Home, Communities, Search and Profile tabs.
  static const String main = '/main';

  static Map<String, WidgetBuilder> get routes {
    return <String, WidgetBuilder>{
      login: (BuildContext context) => const LoginScreen(),
      signUp: (BuildContext context) => const SignUpScreen(),
      main: (BuildContext context) => const MainShell(),
    };
  }

  /// Home Feed / Community Page / Search / Profile -> Post Detail.
  static Future<void> openPost(BuildContext context, String postId) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => PostDetailScreen(postId: postId),
      ),
    );
  }

  /// Communities / Search -> Community Page.
  static Future<void> openCommunity(BuildContext context, String communityId) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return CommunityScreen(communityId: communityId);
        },
      ),
    );
  }

  /// "+" button -> Create Post. Pass [communityId] to pre-select a
  /// community, or [editPostId] to edit an existing post instead.
  static Future<void> openPostForm(
    BuildContext context, {
    String? communityId,
    String? editPostId,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return PostFormScreen(
            initialCommunityId: communityId,
            editPostId: editPostId,
          );
        },
      ),
    );
  }

  /// Closes every screen above the main tabs.
  static void backToMain(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName(main));
  }

  /// Log out -> Login. Removes every other screen from the stack.
  static void logOut(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      login,
      (Route<dynamic> route) => false,
    );
  }
}
