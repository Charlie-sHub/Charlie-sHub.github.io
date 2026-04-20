import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:flutter/material.dart';

/// Shared sizing variants for link-opening buttons.
enum LinkButtonSize {
  /// Compact sticky-profile link button.
  compact,

  /// Default full-width link button for external reference lists.
  standard,

  /// Larger resume link button.
  large,
}

/// Centralizes button styles for reusable presentation controls.
final class AppButtonStyles {
  const AppButtonStyles._();

  /// Warm-accent button treatment used by shared link-opening buttons.
  static ButtonStyle linkButton(
    BuildContext context, {
    required LinkButtonSize size,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return _linkButton(
      context,
      padding: switch (size) {
        LinkButtonSize.compact => AppSpacing.linkButtonCompactPadding,
        LinkButtonSize.standard => AppSpacing.linkButtonPadding,
        LinkButtonSize.large => AppSpacing.linkButtonLargePadding,
      },
      textStyle: switch (size) {
        LinkButtonSize.compact => textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        LinkButtonSize.standard => textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        LinkButtonSize.large => textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      },
    );
  }

  static ButtonStyle _linkButton(
    BuildContext context, {
    required EdgeInsetsGeometry padding,
    required TextStyle? textStyle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.zero),
      padding: WidgetStatePropertyAll(padding),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }

        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return colorScheme.secondary;
        }

        return colorScheme.onSecondary;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.outlineVariant.withValues(alpha: 0.36);
        }

        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed)) {
          return colorScheme.secondaryContainer;
        }

        return colorScheme.secondary;
      }),
      side: const WidgetStatePropertyAll(BorderSide(color: Colors.transparent)),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      textStyle: WidgetStatePropertyAll(textStyle),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadii.pill),
      ),
      overlayColor: WidgetStatePropertyAll(
        AppSurfaceStyles.stateLayerFor(colorScheme.secondary),
      ),
    );
  }
}
