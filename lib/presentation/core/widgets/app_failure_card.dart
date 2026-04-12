import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Displays an application or content-loading failure inside a shared card.
class AppFailureCard extends StatelessWidget {
  /// Creates an app failure card.
  const AppFailureCard({
    required this.failure,
    required this.title,
    super.key,
  });

  /// The failure to display.
  final AppFailure failure;

  /// The short heading shown above the failure message.
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingText(text: title),
          const SizedBox(height: 8),
          Text(
            failure.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
