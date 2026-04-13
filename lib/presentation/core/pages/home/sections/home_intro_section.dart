import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_panel.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Opening section for the current single-page portfolio layout.
class HomeIntroSection extends StatelessWidget {
  /// Creates the opening section.
  const HomeIntroSection({super.key});

  @override
  Widget build(BuildContext context) => const SectionPanel(
    title: 'Portfolio Overview',
    children: [
      HeadingText(
        text: 'Structured portfolio content with explicit validation.',
      ),
      SizedBox(height: AppSpacing.size12),
      BodyText(
        text:
            'The current build renders validated portfolio content through a '
            'small reusable widget bank, with clear fallback handling for '
            'field, item, and section failures.',
      ),
    ],
  );
}
