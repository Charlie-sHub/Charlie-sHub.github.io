part of '../entry_selector_panel.dart';

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
