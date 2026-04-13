import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Builds the first-pass text theme for the portfolio application.
TextTheme buildAppTextTheme() {
  final base = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Geometria',
  ).textTheme;

  return base.copyWith(
    displayMedium: base.displayMedium?.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
      height: 0.96,
      letterSpacing: -1.1,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w700,
      height: 1.08,
      letterSpacing: -0.7,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -0.45,
    ),
    titleLarge: base.titleLarge?.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w700,
      height: 1.18,
      letterSpacing: -0.25,
    ),
    titleMedium: base.titleMedium?.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
      height: 1.22,
      letterSpacing: -0.1,
    ),
    titleSmall: base.titleSmall?.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
      height: 1.24,
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      color: AppColors.textPrimary,
      height: 1.62,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      color: AppColors.textSecondary,
      height: 1.58,
    ),
    bodySmall: base.bodySmall?.copyWith(
      color: AppColors.textMuted,
      height: 1.45,
    ),
    labelLarge: base.labelLarge?.copyWith(
      color: AppColors.coolAccent,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
    labelMedium: base.labelMedium?.copyWith(
      color: AppColors.coolAccent,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.7,
    ),
  );
}
