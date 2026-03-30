import 'package:flutter/material.dart';

/// Shared surface for simple page sections.
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(24),
        color: colorScheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.headlineSmall),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
