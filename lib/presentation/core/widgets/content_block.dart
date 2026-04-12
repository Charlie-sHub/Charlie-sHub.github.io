import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Renders a small titled content block with consistent heading spacing.
class ContentBlock extends StatelessWidget {
  /// Creates a titled content block.
  const ContentBlock({
    required this.title,
    required this.child,
    this.spacing = 8,
    super.key,
  });

  /// The heading text shown above the block content.
  final String title;

  /// The widget rendered below the heading.
  final Widget child;

  /// The vertical spacing between the heading and the child.
  final double spacing;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      HeadingText(text: title),
      SizedBox(height: spacing),
      child,
    ],
  );
}
