import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_experience_item.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Renders the professional experience list in the resume section.
class ResumeExperienceList extends StatelessWidget {
  /// Creates a resume experience list.
  const ResumeExperienceList({
    required this.items,
    super.key,
  });

  /// The experience items to display.
  final List<ResumeExperienceItem> items;

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
          _ResumeExperienceCard(item: items[index]),
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

class _ResumeExperienceCard extends StatelessWidget {
  const _ResumeExperienceCard({
    required this.item,
  });

  final ResumeExperienceItem item;

  @override
  Widget build(BuildContext context) {
    final timelineFailure = ongoingTimelineFailureOrNull(
      startDate: item.startDate,
      endDate: item.endDate,
      isOngoing: item.isOngoing,
    );

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: item.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (item.organization != null) ...[
            const SizedBox(height: 8),
            ValidatedText(
              field: item.organization!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
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
              if (item.endDate != null)
                MetadataItemData(
                  label: 'Ended',
                  value: item.endDate!,
                ),
            ],
          ),
          if (item.isOngoing) ...const [
            SizedBox(height: 12),
            SupportingText(text: 'In progress'),
          ],
          if (timelineFailure != null) ...[
            const SizedBox(height: 12),
            FieldFailureWidget(failure: timelineFailure),
          ],
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Highlights',
            child: ValidatedBulletList(
              items: item.highlights,
              collectionFailure: collectionFailureOrNull(
                item.highlights,
                minLength: 1,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
