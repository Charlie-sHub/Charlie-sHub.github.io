import 'dart:ui';

import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:flutter/material.dart';

/// Provides a shared card-like surface for content blocks.
class ContentCard extends StatefulWidget {
  /// Creates a content card.
  const ContentCard({
    required this.child,
    this.padding = AppSpacing.contentCardPadding,
    this.onTap,
    this.isLink = false,
    this.variant = AppSurfaceVariant.solid,
    this.accentColor,
    super.key,
  });

  /// The content placed inside the card.
  final Widget child;

  /// The internal padding applied to the card.
  final EdgeInsetsGeometry padding;

  /// Optional tap handler for interactive card surfaces.
  final VoidCallback? onTap;

  /// Whether the interactive card represents a link target.
  final bool isLink;

  /// The shared surface treatment for this card.
  final AppSurfaceVariant variant;

  /// Optional accent color override for interactive emphasis and state styling.
  final Color? accentColor;

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final radius = AppSurfaceStyles.radiusFor(widget.variant);
    final content = ClipRRect(
      borderRadius: radius,
      child: _buildSurface(context),
    );

    if (widget.onTap == null) {
      return content;
    }

    return Semantics(
      button: true,
      link: widget.isLink,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHover: _handleHoverChanged,
          onFocusChange: _handleFocusChanged,
          onHighlightChanged: _handlePressedChanged,
          borderRadius: radius,
          overlayColor: WidgetStatePropertyAll(
            AppSurfaceStyles.stateLayerFor(
              widget.accentColor ??
                  (widget.isLink
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary),
            ),
          ),
          child: content,
        ),
      ),
    );
  }

  Widget _buildSurface(BuildContext context) {
    final accentColor = widget.onTap == null
        ? null
        : widget.accentColor ??
              (widget.isLink
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary);
    final surface = AnimatedContainer(
      duration: context.resolveMotionDuration(AppMotion.durationFast),
      curve: context.resolveMotionCurve(AppMotion.curveStandard),
      decoration: AppSurfaceStyles.cardDecoration(
        context,
        variant: widget.variant,
        hovered: _isHovered,
        focused: _isFocused,
        pressed: _isPressed,
        accentColor: accentColor,
      ),
      child: Padding(
        padding: widget.padding,
        child: widget.child,
      ),
    );

    if (widget.variant != AppSurfaceVariant.section) {
      return surface;
    }

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: AppSurfaceStyles.sectionBlurSigma,
        sigmaY: AppSurfaceStyles.sectionBlurSigma,
      ),
      child: surface,
    );
  }

  void _handleFocusChanged(bool isFocused) {
    if (_isFocused == isFocused) {
      return;
    }

    setState(() {
      _isFocused = isFocused;
    });
  }

  void _handleHoverChanged(bool isHovered) {
    if (_isHovered == isHovered) {
      return;
    }

    setState(() {
      _isHovered = isHovered;
    });
  }

  void _handlePressedChanged(bool isPressed) {
    if (_isPressed == isPressed) {
      return;
    }

    setState(() {
      _isPressed = isPressed;
    });
  }
}
