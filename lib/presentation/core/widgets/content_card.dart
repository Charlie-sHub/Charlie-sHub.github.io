import 'package:flutter/material.dart';

/// Provides a shared card-like surface for content blocks.
class ContentCard extends StatelessWidget {
  /// Creates a content card.
  const ContentCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    super.key,
  });

  /// The content placed inside the card.
  final Widget child;

  /// The internal padding applied to the card.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.surface,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
