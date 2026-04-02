import 'package:charlie_shub_portfolio/presentation/widgets/section_panel.dart';
import 'package:flutter/material.dart';

/// Summary of the current project setup.
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
        'Schema-backed content, DTOs, and domain models with explicit '
        'validation state are in '
        'place for the structured content sections.',
      ),
      SizedBox(height: 8),
      Text(
        'Asset loading and Cubit-based application state are still to be '
        'wired into the UI.',
      ),
    ],
  );
}
