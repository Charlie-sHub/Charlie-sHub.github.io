import 'package:charlie_shub_portfolio/presentation/widgets/core/content_card.dart';
import 'package:flutter/material.dart';

/// Builds selector content for one entry in an [EntrySelectorPanel].
typedef EntrySelectorLabelBuilder<T> =
    Widget Function(
      BuildContext context,
      T entry, {
      required bool isSelected,
    });

/// Builds the detail pane for the selected entry in an [EntrySelectorPanel].
typedef EntrySelectorDetailBuilder<T> =
    Widget Function(BuildContext context, T entry);

/// Coordinates selection and detail rendering for dense multi-entry sections.
class EntrySelectorPanel<T> extends StatefulWidget {
  /// Creates an entry selector panel.
  const EntrySelectorPanel({
    required this.entries,
    required this.labelBuilder,
    required this.detailBuilder,
    this.initialSelectedIndex = 0,
    this.compactBreakpoint = 720,
    this.selectorWidth = 260,
    this.gap = 16,
    super.key,
  });

  /// The ordered entries available for selection.
  final List<T> entries;

  /// Builds the selector label content for each entry.
  final EntrySelectorLabelBuilder<T> labelBuilder;

  /// Builds the detail pane for the currently selected entry.
  final EntrySelectorDetailBuilder<T> detailBuilder;

  /// The index selected when the widget is first shown.
  final int initialSelectedIndex;

  /// The width threshold below which the selector stacks above the detail pane.
  final double compactBreakpoint;

  /// The fixed selector width used in wide layouts.
  final double selectorWidth;

  /// The spacing between the selector and detail panes.
  final double gap;

  @override
  State<EntrySelectorPanel<T>> createState() => _EntrySelectorPanelState<T>();
}

class _EntrySelectorPanelState<T> extends State<EntrySelectorPanel<T>> {
  static const _layoutKey = ValueKey<String>('entry-selector-panel-layout');
  static const _selectorPaneKey = ValueKey<String>(
    'entry-selector-panel-selector-pane',
  );
  static const _detailPaneKey = ValueKey<String>(
    'entry-selector-panel-detail-pane',
  );

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = _clampSelectedIndex(widget.initialSelectedIndex);
  }

  @override
  void didUpdateWidget(covariant EntrySelectorPanel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.entries.isEmpty) {
      _selectedIndex = 0;
    } else if (oldWidget.entries.isEmpty && widget.entries.isNotEmpty) {
      _selectedIndex = _clampSelectedIndex(widget.initialSelectedIndex);
    } else if (_selectedIndex >= widget.entries.length) {
      _selectedIndex = widget.entries.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedEntry = widget.entries[_selectedIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < widget.compactBreakpoint;
        final selectorPane = KeyedSubtree(
          key: _selectorPaneKey,
          child: _buildSelectorPane(context),
        );
        final detailPane = KeyedSubtree(
          key: _detailPaneKey,
          child: widget.detailBuilder(context, selectedEntry),
        );

        if (isCompact) {
          return Column(
            key: _layoutKey,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectorPane,
              SizedBox(height: widget.gap),
              detailPane,
            ],
          );
        }

        return Row(
          key: _layoutKey,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: widget.selectorWidth,
              child: selectorPane,
            ),
            SizedBox(width: widget.gap),
            Expanded(child: detailPane),
          ],
        );
      },
    );
  }

  Widget _buildSelectorPane(BuildContext context) {
    final children = <Widget>[];

    for (var index = 0; index < widget.entries.length; index++) {
      if (index > 0) {
        children.add(const SizedBox(height: 8));
      }

      children.add(
        _SelectorButton(
          key: ValueKey<String>('entry-selector-item-$index'),
          isSelected: index == _selectedIndex,
          onPressed: () => _handleSelection(index),
          child: widget.labelBuilder(
            context,
            widget.entries[index],
            isSelected: index == _selectedIndex,
          ),
        ),
      );
    }

    return ContentCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  int _clampSelectedIndex(int index) {
    if (widget.entries.isEmpty) {
      return 0;
    }

    if (index < 0) {
      return 0;
    }

    if (index >= widget.entries.length) {
      return widget.entries.length - 1;
    }

    return index;
  }

  void _handleSelection(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }
}

class _SelectorButton extends StatelessWidget {
  const _SelectorButton({
    required this.child,
    required this.isSelected,
    required this.onPressed,
    super.key,
  });

  final Widget child;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(16),
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.08)
                  : colorScheme.surface,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
