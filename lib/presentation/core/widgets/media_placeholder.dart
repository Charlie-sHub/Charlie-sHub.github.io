import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Provides a reusable placeholder for media-backed content areas.
class MediaPlaceholder extends StatelessWidget {
  /// Creates a media placeholder.
  const MediaPlaceholder({
    required this.label,
    this.height = 180,
    this.icon = Icons.image_outlined,
    super.key,
  });

  /// The placeholder label to display.
  final String label;

  /// The placeholder height.
  final double height;

  /// The icon shown above the placeholder label.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ContentCard(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 12),
              SupportingText(text: label),
            ],
          ),
        ),
      ),
    );
  }
}
