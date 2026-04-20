import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Renders a small titled content block with consistent heading spacing.
class ContentBlock extends StatelessWidget {
  /// Creates a titled content block.
  const ContentBlock({
    required this.title,
    required this.child,
    this.spacing = AppSpacing.size8,
    this.titleStyle,
    super.key,
  });

  /// The heading text shown above the block content.
  final String title;

  /// The widget rendered below the heading.
  final Widget child;

  /// The vertical spacing between the heading and the child.
  final double spacing;

  /// Optional heading style override for cases that should not use the
  /// emphasized shared content-block title treatment.
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: titleStyle ?? AppTextStyles.contentBlockTitle(context),
      ),
      SizedBox(height: spacing),
      child,
    ],
  );
}
