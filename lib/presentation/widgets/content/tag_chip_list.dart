import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/field_failure_widget.dart';
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
      spacing: 8,
      runSpacing: 8,
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(999),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Text(
          label,
          style: textTheme.labelLarge,
        ),
      ),
    );
  }
}
