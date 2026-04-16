import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
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
      variant: AppSurfaceVariant.failure,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: colorScheme.error,
              ),
              const SizedBox(width: AppSpacing.size8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.heading(context)?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.size8),
          Text(
            failure.message,
            style: AppTextStyles.bodyCompact(context)?.copyWith(
              color: colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
    );
  }
}
