import 'package:charlie_shub_portfolio/presentation/widgets/section_panel.dart';
import 'package:flutter/material.dart';

/// Opening section for the first-pass home page.
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
          'Portfolio site rebuild in progress.',
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        const Text(
          'This first pass replaces the starter Flutter example and '
          'establishes the initial project structure for the portfolio site.',
        ),
      ],
    );
  }
}
