import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Shared surface for simple non-content-driven page sections.
class SectionPanel extends StatelessWidget {
  /// Creates a section panel.
  const SectionPanel({
    required this.title,
    required this.children,
    super.key,
  });

  /// Title shown at the top of the panel.
  final String title;

  /// Content displayed below the title.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SectionContainer(
    heading: SectionHeadingText(
      text: title,
    ),
    children: children,
  );
}
