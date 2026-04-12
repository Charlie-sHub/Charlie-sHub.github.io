import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_education_item.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Renders the education list in the resume section.
class ResumeEducationList extends StatelessWidget {
  /// Creates a resume education list.
  const ResumeEducationList({
    required this.items,
    super.key,
  });

  /// The education items to display.
  final List<ResumeEducationItem> items;

  @override
  Widget build(BuildContext context) {
    final collectionFailure = collectionFailureOrNull(
      items,
      minLength: 1,
    );

    if (collectionFailure != null) {
      return FieldFailureWidget(
        failure: collectionFailure,
      );
    } else {
      final children = <Widget>[];

      for (var index = 0; index < items.length; index++) {
        children.add(
          _ResumeEducationCard(item: items[index]),
        );

        if (index < items.length - 1) {
          children.add(const SizedBox(height: 12));
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }
  }
}

class _ResumeEducationCard extends StatelessWidget {
  const _ResumeEducationCard({
    required this.item,
  });

  final ResumeEducationItem item;

  @override
  Widget build(BuildContext context) {
    final dateFailure = dateRangeFailureOrNull(
      startDate: item.startDate,
      endDate: item.endDate,
    );

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: item.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ValidatedText(
            field: item.institution,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          MetadataRow(
            items: [
              MetadataItemData(
                label: 'Location',
                value: item.location,
              ),
              MetadataItemData(
                label: 'Started',
                value: item.startDate,
              ),
              MetadataItemData(
                label: 'Ended',
                value: item.endDate,
              ),
            ],
          ),
          if (dateFailure != null) ...[
            const SizedBox(height: 12),
            FieldFailureWidget(failure: dateFailure),
          ],
        ],
      ),
    );
  }
}
