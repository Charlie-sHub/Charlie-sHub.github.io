import 'dart:async';
import 'dart:ui';

import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:flutter/widgets.dart';

/// Reveals content once on first load with a short fade and upward drift.
class InitialLoadReveal extends StatefulWidget {
  /// Creates a one-time first-load reveal wrapper.
  const InitialLoadReveal({
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppMotion.durationStandard,
    this.curve = AppMotion.curveSmooth,
    this.beginOffset = const Offset(0, AppMotion.distanceSmall),
    this.beginOpacity = 0,
    super.key,
  });

  /// The child shown after the reveal completes.
  final Widget child;

  /// Optional delay used for light staggering between major groups.
  final Duration delay;

  /// The total reveal duration.
  final Duration duration;

  /// The motion curve used for the reveal.
  final Curve curve;

  /// The starting offset that drifts into the final resting position.
  final Offset beginOffset;

  /// The initial opacity before the content fully appears.
  final double beginOpacity;

  @override
  State<InitialLoadReveal> createState() => _InitialLoadRevealState();
}

class _InitialLoadRevealState extends State<InitialLoadReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _startTimer;
  bool _hasStarted = false;

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

    if (_hasStarted) {
      return;
    }

    _hasStarted = true;

    if (context.prefersReducedMotion) {
      _controller.value = 1;
    } else if (widget.delay == Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_controller.forward());
        }
      });
    } else {
      _startTimer = Timer(widget.delay, () {
        if (mounted) {
          unawaited(_controller.forward());
        }
      });
    }
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.prefersReducedMotion) {
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
}
