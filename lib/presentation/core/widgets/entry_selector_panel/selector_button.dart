part of '../entry_selector_panel.dart';

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
