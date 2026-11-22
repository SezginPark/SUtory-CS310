import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'state/app_state.dart';
import 'state/app_state_scope.dart';
import 'theme/app_theme.dart';

/// Root widget of SUtory. It owns the shared [AppState] and exposes it to
/// every screen through [AppStateScope].
class SutoryApp extends StatefulWidget {
  const SutoryApp({super.key});

  @override
  State<SutoryApp> createState() => _SutoryAppState();
}

class _SutoryAppState extends State<SutoryApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: MaterialApp(
        title: 'SUtory',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      ),
    );
  }
}
