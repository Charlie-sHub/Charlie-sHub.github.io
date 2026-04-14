import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

/// Builds the current application theme scaffold.
ThemeData buildAppTheme() {
  final colorScheme =
      const ColorScheme.light(
        primary: AppColors.coolAccent,
        onPrimary: AppColors.chalk,
        primaryContainer: AppColors.coolAccentSoft,
        onPrimaryContainer: AppColors.textPrimary,
        secondary: AppColors.warmAccent,
        onSecondary: AppColors.chalk,
        secondaryContainer: AppColors.warmAccentSoft,
        onSecondaryContainer: AppColors.textPrimary,
        tertiary: AppColors.graphite,
        onTertiary: AppColors.chalk,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.failureStrong,
        onError: AppColors.chalk,
        errorContainer: AppColors.failureContainer,
        onErrorContainer: AppColors.onFailureContainer,
        outline: AppColors.border,
        outlineVariant: AppColors.borderSoft,
        shadow: AppColors.shadow,
        scrim: AppColors.graphite,
      ).copyWith(
        surfaceContainerLowest: AppColors.surface,
        surfaceContainerLow: AppColors.surfaceElevated,
        surfaceContainer: AppColors.surfaceSecondary,
        surfaceContainerHigh: AppColors.surfaceSecondary,
        surfaceContainerHighest: AppColors.surfaceMuted,
        onSurfaceVariant: AppColors.textSecondary,
        surfaceTint: Colors.transparent,
      );
  final textTheme = buildAppTextTheme();

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    fontFamily: 'Geometria',
    scaffoldBackgroundColor: AppColors.canvas,
    canvasColor: AppColors.canvas,
    dividerColor: colorScheme.outlineVariant,
    shadowColor: AppColors.shadow,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    textTheme: textTheme,
    iconTheme: IconThemeData(
      color: colorScheme.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }

          return colorScheme.secondary;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.secondaryContainer;
          }

          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return colorScheme.secondaryContainer.withValues(alpha: 0.92);
          }

          return colorScheme.secondaryContainer.withValues(alpha: 0.7);
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: colorScheme.outlineVariant,
            );
          }

          if (states.contains(WidgetState.pressed)) {
            return BorderSide(
              color: colorScheme.secondary.withValues(alpha: 0.56),
            );
          }

          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return BorderSide(
              color: colorScheme.secondary.withValues(alpha: 0.48),
            );
          }

          return BorderSide(
            color: colorScheme.secondary.withValues(alpha: 0.34),
          );
        }),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        textStyle: WidgetStatePropertyAll(
          textTheme.labelLarge?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: AppSpacing.size8,
            vertical: AppSpacing.size4,
          ),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: AppRadii.control),
        ),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: WidgetStatePropertyAll(
          AppSurfaceStyles.stateLayerFor(colorScheme.secondary),
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shadowColor: AppColors.shadow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.section,
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
    ),
  );
}
