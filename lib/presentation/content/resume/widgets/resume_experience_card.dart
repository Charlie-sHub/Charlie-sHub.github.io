import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_experience_item.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// One professional-experience card inside the resume section.
class ResumeExperienceCard extends StatelessWidget {
  /// Creates a resume experience card.
  const ResumeExperienceCard({
    required this.item,
    super.key,
  });

  /// The experience item to render.
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
            style: AppTextStyles.contentTitleCompact(context),
          ),
          if (item.organization != null) ...[
            const SizedBox(height: AppSpacing.size8),
            ValidatedText(
              field: item.organization!,
              style: AppTextStyles.contentSubtitle(context),
            ),
          ],
          const SizedBox(height: AppSpacing.size12),
          MetadataRow(
            items: [
              MetadataItemData(
                label: 'Location',
                value: item.location,
                icon: Icons.place_outlined,
              ),
              MetadataItemData(
                label: 'Started',
                value: item.startDate,
                icon: Icons.calendar_month_outlined,
              ),
              if (item.endDate != null)
                MetadataItemData(
                  label: 'Ended',
                  value: item.endDate!,
                  icon: Icons.event_available_outlined,
                ),
            ],
          ),
          if (item.isOngoing) ...const [
            SizedBox(height: AppSpacing.size12),
            SupportingText(text: 'In progress'),
          ],
          if (timelineFailure != null) ...[
            const SizedBox(height: AppSpacing.size12),
            FieldFailureWidget(failure: timelineFailure),
          ],
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'Highlights',
            titleStyle: AppTextStyles.contentTitleCompact(context),
            child: ValidatedBulletList(
              items: item.highlights,
              collectionFailure: collectionFailureOrNull(
                item.highlights,
                minLength: 1,
              ),
              style: AppTextStyles.bodyCompact(context),
            ),
          ),
        ],
      ),
    );
  }
}
