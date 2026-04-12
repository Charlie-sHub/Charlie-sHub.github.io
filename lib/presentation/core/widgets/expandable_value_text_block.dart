import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/expandable_text_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Renders validated long-form text with explicit failure handling and
/// progressive disclosure.
class ExpandableValueTextBlock extends StatelessWidget {
  /// Creates an expandable validated text block.
  const ExpandableValueTextBlock({
    required this.field,
    this.style,
    this.collapsedMaxLines = 4,
    this.readMoreLabel = 'Read more',
    this.showLessLabel = 'Show less',
    super.key,
  });

  /// The validated text field to render.
  final ValueObject<String> field;

  /// Optional text style for the rendered content.
  final TextStyle? style;

  /// The number of lines to show before disclosure is needed.
  final int collapsedMaxLines;

  /// The label shown when the content is collapsed.
  final String readMoreLabel;

  /// The label shown when the content is expanded.
  final String showLessLabel;

  @override
  Widget build(BuildContext context) => field.value.fold(
    (failure) => FieldFailureWidget(
      failure: failure,
    ),
    (value) => ExpandableTextBlock(
      text: value,
      style: style,
      collapsedMaxLines: collapsedMaxLines,
      readMoreLabel: readMoreLabel,
      showLessLabel: showLessLabel,
    ),
  );
}
