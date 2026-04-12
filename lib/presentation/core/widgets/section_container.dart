import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:flutter/material.dart';

/// Wraps a section in a shared container with optional heading content.
class SectionContainer extends StatelessWidget {
  /// Creates a section container.
  const SectionContainer({
    required this.children,
    this.heading,
    super.key,
  });

  /// The heading widget shown above the section body.
  final Widget? heading;

  /// The section content displayed inside the container.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ContentCard(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading case final heading?) ...[
          heading,
          if (children.isNotEmpty) const SizedBox(height: 16),
        ],
        ...children,
      ],
    ),
  );
}
