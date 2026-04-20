import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
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
    this.compactBreakpoint = AppLayout.entrySelectorCompactBreakpoint,
    this.selectorWidth = AppLayout.entrySelectorWidth,
    this.gap = AppSpacing.size16,
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
  int _selectionDirection = 1;

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
          child: _AnimatedEntryDetailPane(
            selectedIndex: _selectedIndex,
            selectionDirection: _selectionDirection,
            child: widget.detailBuilder(context, selectedEntry),
          ),
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
        children.add(const SizedBox(height: AppSpacing.size8));
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
      padding: AppSpacing.selectorPanelPadding,
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
      _selectionDirection = index > _selectedIndex ? 1 : -1;
      _selectedIndex = index;
    });
  }
}

class _AnimatedEntryDetailPane extends StatelessWidget {
  const _AnimatedEntryDetailPane({
    required this.selectedIndex,
    required this.selectionDirection,
    required this.child,
  });

  final int selectedIndex;
  final int selectionDirection;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final keyedChild = KeyedSubtree(
      key: ValueKey<int>(selectedIndex),
      child: child,
    );

    if (context.prefersReducedMotion) {
      return keyedChild;
    }

    final duration = context.resolveMotionDuration(AppMotion.durationStandard);
    final curve = context.resolveMotionCurve(AppMotion.curveSmooth);

    return ClipRect(
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: curve,
        switchOutCurve: context.resolveMotionCurve(AppMotion.curveStandard),
        layoutBuilder: (currentChild, previousChildren) => Stack(
          alignment: Alignment.topLeft,
          children: [
            ...previousChildren,
            ...?currentChild == null ? null : [currentChild],
          ],
        ),
        transitionBuilder: (child, animation) {
          final isIncomingChild = child.key == ValueKey<int>(selectedIndex);
          final incomingOffset = Offset(
            context.resolveMotionDistance(AppMotion.distanceSmall) *
                selectionDirection,
            0,
          );

          if (!isIncomingChild) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }

          return AnimatedBuilder(
            animation: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
            builder: (context, child) {
              final dx = Tween<double>(
                begin: incomingOffset.dx,
                end: 0,
              ).transform(animation.value);

              return Transform.translate(
                offset: Offset(dx, 0),
                child: child,
              );
            },
          );
        },
        child: keyedChild,
      ),
    );
  }
}

class _SelectorButton extends StatefulWidget {
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
  State<_SelectorButton> createState() => _SelectorButtonState();
}

class _SelectorButtonState extends State<_SelectorButton> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final duration = context.resolveMotionDuration(AppMotion.durationFast);
    final curve = context.resolveMotionCurve(AppMotion.curveStandard);

    return Semantics(
      button: true,
      selected: widget.isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          onHover: _handleHoverChanged,
          onFocusChange: _handleFocusChanged,
          onHighlightChanged: _handlePressedChanged,
          borderRadius: AppRadii.control,
          overlayColor: WidgetStatePropertyAll(
            AppSurfaceStyles.stateLayerFor(colorScheme.secondary),
          ),
          child: AnimatedContainer(
            duration: duration,
            curve: curve,
            decoration: AppSurfaceStyles.selectorDecoration(
              context,
              isSelected: widget.isSelected,
              hovered: _isHovered,
              focused: _isFocused,
              pressed: _isPressed,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: AppSpacing.size6,
                  top: AppSpacing.size10,
                  bottom: AppSpacing.size10,
                  child: AnimatedContainer(
                    duration: duration,
                    curve: curve,
                    width: widget.isSelected ? AppSpacing.size4 : 0,
                    decoration: BoxDecoration(
                      borderRadius: AppRadii.pill,
                      color: widget.isSelected
                          ? colorScheme.secondary
                          : Colors.transparent,
                    ),
                  ),
                ),
                Padding(
                  padding: AppSpacing.selectorButtonPadding,
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleFocusChanged(bool isFocused) {
    if (_isFocused == isFocused) {
      return;
    }

    setState(() {
      _isFocused = isFocused;
    });
  }

  void _handleHoverChanged(bool isHovered) {
    if (_isHovered == isHovered) {
      return;
    }

    setState(() {
      _isHovered = isHovered;
    });
  }

  void _handlePressedChanged(bool isPressed) {
    if (_isPressed == isPressed) {
      return;
    }

    setState(() {
      _isPressed = isPressed;
    });
  }
}
