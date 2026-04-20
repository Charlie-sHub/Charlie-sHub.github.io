import 'package:flutter/material.dart';

/// Shared framed preview wrapper for fixed-height media and document surfaces.
class PreviewFrameSurface extends StatelessWidget {
  /// Creates a framed preview surface.
  const PreviewFrameSurface({
    required this.height,
    required this.child,
    required this.borderRadius,
    this.color,
    this.border,
    super.key,
  });

  /// Fixed preview height used by the framed content.
  final double height;

  /// Inner preview content rendered inside the clipped frame.
  final Widget child;

  /// Border radius used for the clipped preview content.
  final BorderRadius borderRadius;

  /// Optional background color applied around the preview content.
  final Color? color;

  /// Optional border applied around the preview content.
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      border: border,
      borderRadius: borderRadius,
    ),
    child: ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: child,
      ),
    ),
  );
}
