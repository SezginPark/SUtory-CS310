import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../state/app_state.dart';
import '../state/app_state_scope.dart';
import '../widgets/app_bottom_nav.dart';
import 'communities_screen.dart';
import 'home_feed_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

/// The main app after login: app bar, the four tabs and the bottom
/// navigation bar. The selected tab lives in [AppState], so other screens
/// can switch tabs too.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final int index = state.tabIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppBottomNav.titles[index]),
        automaticallyImplyLeading: false,
      ),
      // IndexedStack keeps every tab alive, so scroll position and the
      // search text are not lost when switching tabs.
      body: SafeArea(
        child: IndexedStack(
          index: index,
          children: const <Widget>[
            HomeFeedScreen(),
            CommunitiesScreen(),
            SearchScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton(
              heroTag: 'home-new-post',
              tooltip: 'New post',
              onPressed: () => AppRoutes.openPostForm(context),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: AppBottomNav(
        currentIndex: index,
        onTap: state.selectTab,
      ),
    );
  }
}
