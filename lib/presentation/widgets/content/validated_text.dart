import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Renders validated text while surfacing field-level failures explicitly.
class ValidatedText extends StatelessWidget {
  /// Creates a validated text widget.
  const ValidatedText({
    required this.field,
    this.maxLines,
    this.overflow,
    this.style,
    this.textAlign,
    super.key,
  });

  /// The validated field to render.
  final ValueObject<String> field;

  /// The maximum number of lines to display.
  final int? maxLines;

  /// The overflow behavior for the rendered text.
  final TextOverflow? overflow;

  /// The text style to apply on success.
  final TextStyle? style;

  /// The alignment of the rendered text.
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => field.value.fold(
    (failure) => FieldFailureWidget(
      failure: failure,
    ),
    (value) => Text(
      value,
      maxLines: maxLines,
      overflow: overflow,
      style: style,
      textAlign: textAlign,
    ),
  );
}
