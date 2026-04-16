import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Displays the primary and secondary content used in an entry selector item.
class EntrySelectorLabel extends StatelessWidget {
  /// Creates an entry selector label.
  const EntrySelectorLabel({
    required this.title,
    this.subtitle,
    super.key,
  });

  /// The primary selector label content.
  final Widget title;

  /// Optional secondary selector label content.
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title,
      if (subtitle case final subtitle?) ...[
        const SizedBox(height: AppSpacing.size4),
        subtitle,
      ],
    ],
  );
}

/// Explains that a selector item is unavailable while keeping the failure
/// local.
class UnavailableEntrySelectorLabel extends StatelessWidget {
  /// Creates an unavailable entry selector label.
  const UnavailableEntrySelectorLabel({
    required this.title,
    required this.isSelected,
    this.message = 'Select to view failure details.',
    super.key,
  });

  /// The unavailable item title shown in the selector.
  final String title;

  /// Whether the selector item is currently active.
  final bool isSelected;

  /// Supporting guidance shown below the unavailable title.
  final String message;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: AppTextStyles.selectorTitleState(
          context,
          isSelected: isSelected,
        ),
      ),
      const SizedBox(height: AppSpacing.size4),
      Text(
        message,
        style: AppTextStyles.selectorSupporting(context),
      ),
    ],
  );
}
