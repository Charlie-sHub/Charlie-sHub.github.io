import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/viewport_entry_reveal.dart';
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
  Widget build(BuildContext context) {
    if (heading == null && children.isEmpty) {
      return const SizedBox.shrink();
    }

    final sectionChildren = <Widget>[];

    if (heading != null) {
      sectionChildren.add(heading!);
    }

    if (heading != null && children.isNotEmpty) {
      sectionChildren.add(const SizedBox(height: AppSpacing.size12));
    }

    sectionChildren.addAll(children);

    return ViewportEntryReveal(
      child: ContentCard(
        variant: AppSurfaceVariant.section,
        padding: AppSpacing.sectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sectionChildren,
        ),
      ),
    );
  }
}
