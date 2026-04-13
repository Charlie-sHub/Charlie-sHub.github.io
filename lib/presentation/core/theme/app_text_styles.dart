// Shared token names are kept short and self-describing to avoid noisy
// boilerplate docs on every constant.
// ignore_for_file: public_member_api_docs

import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Centralizes text-theme slot selection for shared presentation widgets.
final class AppTextStyles {
  const AppTextStyles._();

  static TextStyle? sectionHeading(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: AppColors.textOnWallpaper,
        shadows: const [
          Shadow(
            color: AppColors.textOnWallpaperShadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      );

  static TextStyle? authorName(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium?.copyWith(
        fontFamily: 'MovingSkate',
        fontFamilyFallback: const ['Geometria'],
        color: AppColors.warmAccent,
        height: 0.9,
        shadows: const [
          Shadow(
            color: AppColors.textOnWallpaperShadow,
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      );

  static TextStyle? heading(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium;

  static TextStyle? selectorTitle(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall;

  static TextStyle? body(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge;

  static TextStyle? bodyCompact(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium;

  static TextStyle? supporting(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall;

  static TextStyle? metadataLabel(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium;

  static TextStyle? tag(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge;
}
