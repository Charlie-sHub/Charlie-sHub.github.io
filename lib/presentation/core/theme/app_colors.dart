// Shared token names are kept short and self-describing to avoid noisy
// boilerplate docs on every constant.
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// First-pass palette and semantic color roles for the portfolio theme.
final class AppColors {
  const AppColors._();

  static const Color graphite = Color(0xFF1A2225);
  static const Color deepTeal = Color(0xFF0D4449);
  static const Color ember = Color(0xFFA64C23);
  static const Color chalk = Color(0xFFE6E6E4);

  static const Color canvas = Color(0xFFF1EBE4);
  static const Color surface = Color(0xFFFDFBF8);
  static const Color surfaceElevated = Color(0xFFF8F4EF);
  static const Color surfaceSecondary = Color(0xFFF2ECE4);
  static const Color surfaceMuted = Color(0xFFE8E1D7);
  static const Color surfaceGlass = Color(0x80F5F0E8);
  static const Color surfaceGlassHover = Color(0xA0F8F4EC);
  static const Color surfaceGlassPressed = Color(0xB0FBF7F0);
  static const Color surfaceGlassBorder = Color(0x74E2DDD5);
  static const Color surfaceGlassBorderStrong = Color(0x98E2DDD5);

  static const Color border = Color(0xFFAEA59A);
  static const Color borderSoft = Color(0xFFD3CCC3);

  static const Color textPrimary = graphite;
  static const Color textSecondary = Color(0xFF435356);
  static const Color textMuted = Color(0xFF66767A);
  static const Color textOnWallpaper = chalk;
  static const Color textOnWallpaperShadow = Color(0xA61A2225);

  static const Color warmAccent = ember;
  static const Color warmAccentSoft = Color(0xFFF1DDD2);
  static const Color coolAccent = deepTeal;
  static const Color coolAccentSoft = Color(0xFFD6E5E6);
  static const Color coolAccentMuted = Color(0xFFE9F0F0);

  static const Color shadowSoft = Color(0x161A2225);
  static const Color shadow = Color(0x281A2225);

  static const Color failure = Color(0xFFC53931);
  static const Color failureStrong = Color(0xFF8F1F1A);
  static const Color failureContainer = Color(0xFFFBE2DF);
  static const Color failureContainerStrong = Color(0xFFF4CAC4);
  static const Color onFailureContainer = Color(0xFF611915);
}
