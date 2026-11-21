import 'package:flutter/widgets.dart';

import 'app_state.dart';

/// Makes the shared [AppState] available to every widget below it.
///
/// Widgets that call `AppStateScope.of(context)` are rebuilt automatically
/// whenever the state calls `notifyListeners()`.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  /// Reads the state and subscribes the calling widget to changes.
  static AppState of(BuildContext context) {
    final AppStateScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found above this widget.');
    return scope!.notifier!;
  }

  /// Reads the state without subscribing. Use this inside callbacks such as
  /// `onPressed`, where the widget does not need to rebuild.
  static AppState read(BuildContext context) {
    final AppStateScope? scope =
        context.getInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found above this widget.');
    return scope!.notifier!;
  }
}
