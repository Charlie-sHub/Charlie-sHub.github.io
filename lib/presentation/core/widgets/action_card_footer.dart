import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Shared title, subtitle, and action affordance used by clickable card
/// surfaces that open external resources.
class ActionCardFooter extends StatelessWidget {
  /// Creates an action card footer.
  const ActionCardFooter({
    required this.label,
    required this.actionLabel,
    this.subtitle,
    this.actionIcon = Icons.open_in_new,
    super.key,
  });

  /// The primary label shown for the resource.
  final String label;

  /// Optional supporting text shown under the label.
  final String? subtitle;

  /// Short action hint shown beside the affordance icon.
  final String actionLabel;

  /// The trailing action icon.
  final IconData actionIcon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingText(text: label),
              if (subtitle case final subtitle?) ...[
                const SizedBox(height: AppSpacing.size4),
                SupportingText(text: subtitle),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.size12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              actionLabel,
              style: AppTextStyles.actionLabel(context),
            ),
            const SizedBox(height: AppSpacing.size4),
            Icon(
              actionIcon,
              color: colorScheme.secondary,
              size: AppLayout.externalLinkIndicatorIconSize,
            ),
          ],
        ),
      ],
    );
  }
}
