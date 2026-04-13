import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Renders a wrap-based list of validated tag or chip values.
class TagChipList extends StatelessWidget {
  /// Creates a tag chip list.
  const TagChipList({
    required this.tags,
    this.collectionFailure,
    super.key,
  });

  /// The validated tag values to render.
  final List<ValueObject<String>> tags;

  /// The collection-level validation failure to render, if any.
  final ValueFailure<dynamic>? collectionFailure;

  @override
  Widget build(BuildContext context) {
    if (collectionFailure != null) {
      return FieldFailureWidget(
        failure: collectionFailure!,
      );
    }

    return Wrap(
      spacing: AppSpacing.size8,
      runSpacing: AppSpacing.size8,
      children: [
        for (final tag in tags)
          tag.value.fold(
            (failure) => FieldFailureWidget(
              failure: failure,
            ),
            (value) => _TagChip(
              label: value,
            ),
          ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: AppSurfaceStyles.tagDecoration(context),
    child: Padding(
      padding: AppSpacing.tagChipPadding,
      child: Text(
        label,
        style: AppTextStyles.tag(context),
      ),
    ),
  );
}
