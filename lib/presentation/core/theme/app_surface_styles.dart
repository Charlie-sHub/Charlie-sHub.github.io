// Shared token names are kept short and self-describing to avoid noisy
// boilerplate docs on every constant.
// ignore_for_file: public_member_api_docs

import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:flutter/material.dart';

/// Shared surface and state styling for reusable presentation widgets.
enum AppSurfaceVariant {
  /// Near-opaque inner surface used for most card content.
  solid,

  /// Blurred translucent surface used for top-level section cards.
  section,

  /// Stronger surface styling for application-level failure states.
  failure,
}

/// Centralizes reusable surface, border, shadow, and state-layer styling.
final class AppSurfaceStyles {
  const AppSurfaceStyles._();

  static const Duration transitionDuration = Duration(milliseconds: 180);
  static const double sectionBlurSigma = 16;

  static BorderRadius radiusFor(AppSurfaceVariant variant) => switch (variant) {
    AppSurfaceVariant.section => AppRadii.section,
    AppSurfaceVariant.failure => AppRadii.feedback,
    AppSurfaceVariant.solid => AppRadii.card,
  };

  static BoxDecoration cardDecoration(
    BuildContext context, {
    required AppSurfaceVariant variant,
    bool hovered = false,
    bool focused = false,
    bool pressed = false,
    Color? accentColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasEmphasis = hovered || focused;
    final interactiveAccentColor = accentColor ?? colorScheme.primary;

    return switch (variant) {
      AppSurfaceVariant.section => BoxDecoration(
        border: Border.all(
          color: hasEmphasis
              ? AppColors.surfaceGlassBorderStrong
              : AppColors.surfaceGlassBorder,
        ),
        borderRadius: radiusFor(variant),
        color: pressed
            ? AppColors.surfaceGlassPressed
            : hasEmphasis
            ? AppColors.surfaceGlassHover
            : AppColors.surfaceGlass,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: hasEmphasis ? 18 : 14,
            offset: Offset(0, hasEmphasis ? 8 : 6),
          ),
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: hasEmphasis ? 34 : 28,
            offset: Offset(0, hasEmphasis ? 18 : 14),
          ),
        ],
      ),
      AppSurfaceVariant.failure => BoxDecoration(
        border: Border.all(color: AppColors.failureStrong),
        borderRadius: radiusFor(variant),
        color: pressed
            ? AppColors.failureContainerStrong
            : AppColors.failureContainer,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      AppSurfaceVariant.solid => BoxDecoration(
        border: Border.all(
          color: pressed
              ? interactiveAccentColor.withValues(alpha: 0.42)
              : hasEmphasis
              ? interactiveAccentColor.withValues(alpha: 0.28)
              : colorScheme.outlineVariant,
        ),
        borderRadius: radiusFor(variant),
        color: hasEmphasis ? AppColors.surfaceElevated : AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: hasEmphasis ? 12 : 8,
            offset: Offset(0, hasEmphasis ? 6 : 4),
          ),
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: hasEmphasis ? 20 : 16,
            offset: Offset(0, hasEmphasis ? 12 : 10),
          ),
        ],
      ),
    };
  }

  static BoxDecoration selectorDecoration(
    BuildContext context, {
    required bool isSelected,
    bool hovered = false,
    bool focused = false,
    bool pressed = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasEmphasis = hovered || focused;

    return BoxDecoration(
      border: Border.all(
        color: isSelected
            ? colorScheme.primary
            : hasEmphasis
            ? colorScheme.primary.withValues(alpha: 0.26)
            : colorScheme.outlineVariant,
      ),
      borderRadius: AppRadii.control,
      color: isSelected
          ? AppColors.coolAccentSoft
          : pressed
          ? AppColors.surfaceSecondary
          : hasEmphasis
          ? AppColors.surfaceElevated
          : AppColors.surface,
      boxShadow: hasEmphasis || isSelected
          ? const [
              BoxShadow(
                color: AppColors.shadowSoft,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ]
          : const [],
    );
  }

  static BoxDecoration tagDecoration(BuildContext context) => BoxDecoration(
    border: Border.all(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
    ),
    borderRadius: AppRadii.pill,
    color: AppColors.coolAccentMuted,
  );

  static Color stateLayerFor(Color color) => color.withValues(alpha: 0.08);
}
