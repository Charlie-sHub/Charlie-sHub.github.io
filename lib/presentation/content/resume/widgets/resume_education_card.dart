import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_education_item.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// One education entry card inside the resume section.
class ResumeEducationCard extends StatelessWidget {
  /// Creates a resume education card.
  const ResumeEducationCard({
    required this.item,
    super.key,
  });

  /// The education item to render.
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
            style: AppTextStyles.contentTitleCompact(context),
          ),
          const SizedBox(height: AppSpacing.size8),
          ValidatedText(
            field: item.institution,
            style: AppTextStyles.contentSubtitle(context),
          ),
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
              MetadataItemData(
                label: 'Ended',
                value: item.endDate,
                icon: Icons.event_available_outlined,
              ),
            ],
          ),
          if (dateFailure != null) ...[
            const SizedBox(height: AppSpacing.size12),
            FieldFailureWidget(failure: dateFailure),
          ],
        ],
      ),
    );
  }
}
