import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/tag_chip_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Renders a labeled group of validated tags inside a shared card.
class LabeledTagGroupCard extends StatelessWidget {
  /// Creates a labeled tag group card.
  const LabeledTagGroupCard({
    required this.label,
    required this.items,
    this.collectionFailure,
    super.key,
  });

  /// The validated group label.
  final ValueObject<String> label;

  /// The validated items displayed as tags.
  final List<ValueObject<String>> items;

  /// The collection-level validation failure to render, if any.
  final ValueFailure<dynamic>? collectionFailure;

  @override
  Widget build(BuildContext context) => ContentCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValidatedText(
          field: label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        TagChipList(
          tags: items,
          collectionFailure: collectionFailure,
        ),
      ],
    ),
  );
}
