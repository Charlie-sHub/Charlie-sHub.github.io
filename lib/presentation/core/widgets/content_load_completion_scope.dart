import 'package:flutter/widgets.dart';

/// Exposes whether the main content-loading flow has completed for
/// presentation-only progressive enhancements.
class ContentLoadCompletionScope extends InheritedWidget {
  /// Creates a content-load completion scope.
  const ContentLoadCompletionScope({
    required this.isComplete,
    required super.child,
    super.key,
  });

  /// Whether the main content-loading orchestration has completed.
  final bool isComplete;

  /// Returns whether the main content-loading flow has completed.
  ///
  /// Defaults to `true` when no scope is present so standalone widget tests
  /// and isolated surfaces can still render their enhancements.
  static bool isCompleteOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ContentLoadCompletionScope>();

    if (scope == null) {
      return true;
    } else {
      return scope.isComplete;
    }
  }

  @override
  bool updateShouldNotify(ContentLoadCompletionScope oldWidget) =>
      oldWidget.isComplete != isComplete;
}
