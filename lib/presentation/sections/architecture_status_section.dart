import 'package:charlie_shub_portfolio/presentation/widgets/section_panel.dart';
import 'package:flutter/material.dart';

/// Summary of the current first-pass project setup.
class ArchitectureStatusSection extends StatelessWidget {
  /// Creates the architecture summary section.
  const ArchitectureStatusSection({super.key});

  @override
  Widget build(BuildContext context) => const SectionPanel(
      title: 'Current setup',
      children: [
        Text(
          'Flutter Web now runs from a small presentation scaffold.',
        ),
        SizedBox(height: 8),
        Text(
          'The application, domain, and data layers are in place for later '
          'passes.',
        ),
        SizedBox(height: 8),
        Text(
          'Content loading, validation, and Cubit behavior stay intentionally '
          'open for the next step.',
        ),
      ],
    );
}
