import 'dart:async';
import 'dart:ui';

import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:flutter/widgets.dart';

/// Reveals content once when it first enters the viewport.
class ViewportEntryReveal extends StatefulWidget {
  /// Creates a one-time viewport-entry reveal wrapper.
  const ViewportEntryReveal({
    required this.child,
    this.duration = AppMotion.durationStandard,
    this.curve = AppMotion.curveSmooth,
    this.beginOffset = const Offset(0, AppMotion.distanceSmall),
    this.beginOpacity = 0,
    super.key,
  });

  /// The content revealed when the widget enters the viewport.
  final Widget child;

  /// The duration used for the reveal transition.
  final Duration duration;

  /// The motion curve used for the reveal transition.
  final Curve curve;

  /// The starting offset for the reveal drift.
  final Offset beginOffset;

  /// The opacity used before the widget has revealed.
  final double beginOpacity;

  @override
  State<ViewportEntryReveal> createState() => _ViewportEntryRevealState();
}

class _ViewportEntryRevealState extends State<ViewportEntryReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  ScrollPosition? _scrollPosition;
  Timer? _initialVisibilityFallbackTimer;
  bool _hasRevealed = false;
  bool _hasCompletedInitialCheck = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (context.prefersReducedMotion) {
      _reveal(animate: false);

      return;
    }

    _attachScrollListener();

    if (_hasCompletedInitialCheck) {
      return;
    }

    _hasCompletedInitialCheck = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _checkViewportVisibility(animateIfVisible: false);
    });

    _initialVisibilityFallbackTimer = Timer(
      context.resolveMotionDuration(AppMotion.durationSlow),
      () {
        if (!mounted) {
          return;
        }

        _checkViewportVisibility(animateIfVisible: false);
      },
    );
  }

  @override
  void dispose() {
    _detachScrollListener();
    _initialVisibilityFallbackTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.prefersReducedMotion || _controller.isCompleted) {
      return widget.child;
    }

    final curve = context.resolveMotionCurve(widget.curve);
    final beginOffset = context.resolveMotionOffset(widget.beginOffset);
    final animation = CurvedAnimation(
      parent: _controller,
      curve: curve,
    );

    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (context, child) {
        final opacity = lerpDouble(
          widget.beginOpacity,
          1,
          animation.value,
        )!;
        final offset = Offset(
          lerpDouble(beginOffset.dx, 0, animation.value)!,
          lerpDouble(beginOffset.dy, 0, animation.value)!,
        );

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: offset,
            child: child,
          ),
        );
      },
    );
  }

  void _attachScrollListener() {
    final scrollableState = Scrollable.maybeOf(context);
    final nextPosition = scrollableState?.position;

    if (_scrollPosition == nextPosition) {
      return;
    }

    _detachScrollListener();
    _scrollPosition = nextPosition;
    _scrollPosition?.addListener(_handleScrollChanged);

    if (_scrollPosition == null) {
      _reveal(animate: false);
    }
  }

  void _checkViewportVisibility({
    required bool animateIfVisible,
  }) {
    if (_hasRevealed) {
      return;
    }

    if (_isInViewport()) {
      _reveal(animate: animateIfVisible);
    }
  }

  void _detachScrollListener() {
    _scrollPosition?.removeListener(_handleScrollChanged);
    _scrollPosition = null;
  }

  void _handleScrollChanged() {
    _checkViewportVisibility(animateIfVisible: true);
  }

  bool _isInViewport() {
    final renderObject = context.findRenderObject();
    final scrollableState = Scrollable.maybeOf(context);
    final viewportRenderObject = scrollableState?.context.findRenderObject();

    if (renderObject is! RenderBox ||
        viewportRenderObject is! RenderBox ||
        !renderObject.hasSize) {
      return false;
    }

    if (!viewportRenderObject.hasSize) {
      return false;
    }

    final targetRect =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;
    final viewportRect =
        viewportRenderObject.localToGlobal(Offset.zero) &
        viewportRenderObject.size;

    return targetRect.bottom > viewportRect.top &&
        targetRect.top < viewportRect.bottom;
  }

  void _reveal({
    required bool animate,
  }) {
    if (_hasRevealed) {
      return;
    }

    _hasRevealed = true;
    _detachScrollListener();
    _initialVisibilityFallbackTimer?.cancel();

    if (animate) {
      unawaited(_controller.forward());
    } else {
      _controller.value = 1;
    }
  }
}
