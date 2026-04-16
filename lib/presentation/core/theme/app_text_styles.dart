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
        color: AppColors.warmAccent,
      );

  static TextStyle? authorName(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium?.copyWith(
        color: AppColors.warmAccent,
        height: 0.9,
      );

  static TextStyle? heading(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium;

  static TextStyle? selectorTitle(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall;

  static TextStyle? selectorTitleState(
    BuildContext context, {
    required bool isSelected,
  }) => selectorTitle(context)?.copyWith(
    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
  );

  static TextStyle? body(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge;

  static TextStyle? bodyCompact(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium;

  static TextStyle? supporting(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall;

  static TextStyle? selectorSupporting(BuildContext context) =>
      supporting(context);

  static TextStyle? metadataLabel(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium;

  static TextStyle? tag(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge;

  static TextStyle? actionLabel(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AppColors.warmAccent,
      );
}
