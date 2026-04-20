import 'dart:async';
import 'dart:ui';

import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:flutter/widgets.dart';

/// Applies a very subtle one-time ambient settle to decorative background
/// layers.
class AmbientBackgroundMotion extends StatefulWidget {
  /// Creates an ambient background motion wrapper.
  const AmbientBackgroundMotion({
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppMotion.durationSlow,
    this.curve = AppMotion.curveSmooth,
    this.beginOpacity = 0.985,
    this.beginScale = 1.008,
    super.key,
  });

  /// The decorative background content.
  final Widget child;

  /// Optional delay before the ambient motion begins.
  final Duration delay;

  /// The duration of the ambient motion.
  final Duration duration;

  /// The easing used for the ambient motion.
  final Curve curve;

  /// The starting opacity for the background layer.
  final double beginOpacity;

  /// The starting scale for the background layer.
  final double beginScale;

  @override
  State<AmbientBackgroundMotion> createState() =>
      _AmbientBackgroundMotionState();
}

class _AmbientBackgroundMotionState extends State<AmbientBackgroundMotion>
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

    final animation = CurvedAnimation(
      parent: _controller,
      curve: context.resolveMotionCurve(widget.curve),
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
        final scale = lerpDouble(
          widget.beginScale,
          1,
          animation.value,
        )!;

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
    );
  }
}
