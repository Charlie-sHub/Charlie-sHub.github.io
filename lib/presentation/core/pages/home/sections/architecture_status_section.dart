import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_panel.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Summary of the current presentation and content-loading setup.
class ArchitectureStatusSection extends StatelessWidget {
  /// Creates the architecture summary section.
  const ArchitectureStatusSection({super.key});

  @override
  Widget build(BuildContext context) => const SectionPanel(
    title: 'Current setup',
    children: [
      BodyText(
        text: 'Flutter Web now renders the full portfolio content set.',
      ),
      SizedBox(height: AppSpacing.size8),
      BodyText(
        text:
            'Schema-backed content, DTOs, and validated domain models drive '
            'the rendered sections through ContentCubit state.',
      ),
      SizedBox(height: AppSpacing.size8),
      BodyText(
        text:
            'Reusable presentation widgets still keep invalid fields, '
            'collection failures, and section-level loading failures visible '
            'instead of hiding them.',
      ),
    ],
  );
}
