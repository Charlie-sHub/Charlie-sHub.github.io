import 'package:flutter/material.dart';

/// Builds the first-pass application theme.
ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFB8672E),
  );

  return ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: const Color(0xFFF6F1EA),
  );
}
