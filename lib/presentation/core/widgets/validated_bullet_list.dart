import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
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

    final textColor = style?.color ?? AppTextStyles.bodyCompact(context)?.color;
    final children = <Widget>[];

    for (var index = 0; index < items.length; index++) {
      children.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppSpacing.bulletMarkerPadding,
              child: Container(
                width: AppLayout.bulletMarkerSize,
                height: AppLayout.bulletMarkerSize,
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
        children.add(const SizedBox(height: AppSpacing.size10));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
