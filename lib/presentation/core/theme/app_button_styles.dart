import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:flutter/material.dart';

/// Shared sizing variants for warm-accent contact buttons.
enum ContactButtonSize {
  /// Compact sticky-profile contact button.
  compact,

  /// Larger resume contact button.
  large,
}

/// Centralizes button styles for reusable presentation controls.
final class AppButtonStyles {
  const AppButtonStyles._();

  /// Warm-accent button treatment used by shared contact-link actions.
  static ButtonStyle contactLink(
    BuildContext context, {
    required ContactButtonSize size,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return _contactLink(
      context,
      padding: switch (size) {
        ContactButtonSize.compact => AppSpacing.contactButtonPadding,
        ContactButtonSize.large => AppSpacing.contactButtonLargePadding,
      },
      textStyle: switch (size) {
        ContactButtonSize.compact => textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        ContactButtonSize.large => textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      },
    );
  }

  static ButtonStyle _contactLink(
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
