import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:flutter/material.dart';

/// Centralizes button styles for reusable presentation controls.
final class AppButtonStyles {
  const AppButtonStyles._();

  /// Small warm-accent button treatment used by sticky-profile contact links.
  static ButtonStyle contactLink(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _contactLink(
      context,
      padding: AppSpacing.contactButtonPadding,
      textStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }

  /// Larger warm-accent button treatment used by resume contact links.
  static ButtonStyle contactLinkLarge(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _contactLink(
      context,
      padding: AppSpacing.contactButtonLargePadding,
      textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
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
