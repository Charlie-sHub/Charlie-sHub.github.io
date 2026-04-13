import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Reusable disclosure control for toggling expanded content in place.
class DisclosureToggleButton extends StatelessWidget {
  /// Creates a disclosure toggle button.
  const DisclosureToggleButton({
    required this.isExpanded,
    required this.expandLabel,
    required this.collapseLabel,
    required this.onPressed,
    this.showIcon = true,
    super.key,
  });

  /// Whether the related content is currently expanded.
  final bool isExpanded;

  /// Label shown while the content is collapsed.
  final String expandLabel;

  /// Label shown while the content is expanded.
  final String collapseLabel;

  /// Callback fired when the disclosure state should toggle.
  final VoidCallback onPressed;

  /// Whether the control should show an expand or collapse icon.
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final label = isExpanded ? collapseLabel : expandLabel;
    final style = TextButton.styleFrom(
      alignment: Alignment.centerLeft,
      minimumSize: Size.zero,
      padding: AppSpacing.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );

    if (showIcon) {
      return TextButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
        ),
        label: Text(label),
      );
    }

    return TextButton(
      onPressed: onPressed,
      style: style,
      child: Text(label),
    );
  }
}
