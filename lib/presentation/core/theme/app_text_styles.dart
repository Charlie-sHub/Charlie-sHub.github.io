// Shared token names are kept short and self-describing to avoid noisy
// boilerplate docs on every constant.
// ignore_for_file: public_member_api_docs

import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Centralizes text-theme slot selection for shared presentation widgets.
final class AppTextStyles {
  const AppTextStyles._();

  static const List<Shadow> _sectionCardTextShadow = <Shadow>[
    Shadow(
      color: Color(0x261A2225),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static TextStyle? sectionTitle(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: AppColors.warmAccent,
        fontSize:
            (Theme.of(context).textTheme.headlineSmall?.fontSize ?? 24) + 2,
        shadows: _sectionCardTextShadow,
      );

  static TextStyle? sectionSubtitle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.warmAccent,
        fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) + 1,
        fontWeight: FontWeight.w500,
        shadows: _sectionCardTextShadow,
      );

  static TextStyle? authorName(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium?.copyWith(
        color: AppColors.warmAccent,
        fontSize: 30,
        height: 0.9,
        shadows: _sectionCardTextShadow,
      );

  static TextStyle? contentSubtitle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppColors.warmAccent,
        fontWeight: FontWeight.w600,
      );

  static TextStyle? contentBlockTitle(BuildContext context) {
    final base = Theme.of(context).textTheme.titleMedium;
    final baseSize = base?.fontSize ?? 16;

    return base?.copyWith(
      color: AppColors.warmAccent,
      fontSize: baseSize * 1.2,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle? contentTitle(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge;

  static TextStyle? contentTitleCompact(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium;

  static TextStyle? selectorTitleState(
    BuildContext context, {
    required bool isSelected,
  }) => Theme.of(context).textTheme.titleSmall?.copyWith(
    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
  );

  static TextStyle? body(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge;

  static TextStyle? bodyCompact(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium;

  static TextStyle? bodySupporting(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall;

  static TextStyle? selectorSupporting(BuildContext context) =>
      bodySupporting(context);

  static TextStyle? metaLabel(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium;

  static TextStyle? label(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge;

  static TextStyle? actionLabel(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.warmAccent,
        fontWeight: FontWeight.w700,
      );
}
