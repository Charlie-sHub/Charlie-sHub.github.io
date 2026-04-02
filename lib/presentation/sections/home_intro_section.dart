import 'package:charlie_shub_portfolio/presentation/widgets/section_panel.dart';
import 'package:flutter/material.dart';

/// Opening section for the current home page scaffold.
class HomeIntroSection extends StatelessWidget {
  /// Creates the opening section.
  const HomeIntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SectionPanel(
      title: 'Charlie Shub',
      children: [
        Text(
          'Portfolio implementation in progress.',
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        const Text(
          'The current build establishes the presentation scaffold together '
          'with the schema-backed content and domain foundations for the '
          'site.',
        ),
      ],
    );
  }
}
