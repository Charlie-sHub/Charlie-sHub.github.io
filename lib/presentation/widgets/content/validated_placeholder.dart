import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/media_placeholder.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Renders a placeholder from a validated resource path without hiding
/// failures.
class ValidatedPlaceholder extends StatelessWidget {
  /// Creates a validated placeholder widget.
  const ValidatedPlaceholder({
    required this.path,
    required this.labelBuilder,
    this.height = 180,
    this.icon = Icons.image_outlined,
    super.key,
  });

  /// The validated path that determines whether the placeholder can render.
  final ValueObject<String> path;

  /// Builds the visible placeholder label from the trusted path value.
  final String Function(String value) labelBuilder;

  /// The placeholder height.
  final double height;

  /// The icon shown for the placeholder.
  final IconData icon;

  @override
  Widget build(BuildContext context) => path.value.fold(
    (failure) => FieldFailureWidget(
      failure: failure,
    ),
    (value) => MediaPlaceholder(
      label: labelBuilder(value),
      height: height,
      icon: icon,
    ),
  );
}
