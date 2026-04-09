import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/validated_text.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Renders a bulleted list of validated text values.
class ValidatedBulletList extends StatelessWidget {
  /// Creates a validated bullet list.
  const ValidatedBulletList({
    required this.items,
    this.collectionFailure,
    this.style,
    super.key,
  });

  /// The validated values to render as bullets.
  final List<ValueObject<String>> items;

  /// The collection-level validation failure to render, if any.
  final ValueFailure<dynamic>? collectionFailure;

  /// The text style applied to each rendered bullet item.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (collectionFailure != null) {
      return FieldFailureWidget(
        failure: collectionFailure!,
      );
    }

    final textColor =
        style?.color ?? Theme.of(context).textTheme.bodyMedium?.color;
    final widgets = <Widget>[];

    for (var index = 0; index < items.length; index++) {
      widgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 6,
                right: 8,
              ),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: textColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Expanded(
              child: ValidatedText(
                field: items[index],
                style: style,
              ),
            ),
          ],
        ),
      );

      if (index < items.length - 1) {
        widgets.add(const SizedBox(height: 10));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
