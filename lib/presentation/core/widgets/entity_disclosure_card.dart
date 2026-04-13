import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/disclosure_toggle_button.dart';
import 'package:flutter/material.dart';

/// Keeps dense entity content light on first scan while allowing deeper detail
/// to expand in place.
class EntityDisclosureCard extends StatefulWidget {
  /// Creates an entity disclosure card.
  const EntityDisclosureCard({
    required this.preview,
    required this.details,
    this.expandLabel = 'View details',
    this.collapseLabel = 'Hide details',
    this.initiallyExpanded = false,
    super.key,
  });

  /// Content always visible on first scan.
  final Widget preview;

  /// Additional content revealed when expanded.
  final Widget details;

  /// Label shown before the details are expanded.
  final String expandLabel;

  /// Label shown after the details are expanded.
  final String collapseLabel;

  /// Whether the detail content should start expanded.
  final bool initiallyExpanded;

  @override
  State<EntityDisclosureCard> createState() => _EntityDisclosureCardState();
}

class _EntityDisclosureCardState extends State<EntityDisclosureCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(covariant EntityDisclosureCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _isExpanded = widget.initiallyExpanded;
    }
  }

  @override
  Widget build(BuildContext context) => ContentCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.preview,
        const SizedBox(height: AppSpacing.size12),
        DisclosureToggleButton(
          isExpanded: _isExpanded,
          expandLabel: widget.expandLabel,
          collapseLabel: widget.collapseLabel,
          onPressed: _toggleExpanded,
        ),
        if (_isExpanded) ...[
          const SizedBox(height: AppSpacing.size16),
          widget.details,
        ],
      ],
    ),
  );

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}
