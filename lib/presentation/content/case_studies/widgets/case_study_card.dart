import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entity_disclosure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/expandable_value_text_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/link_button_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Displays one fully rendered case-study entry.
class CaseStudyCard extends StatelessWidget {
  /// Creates a case-study card.
  const CaseStudyCard({
    required this.caseStudy,
    super.key,
  });

  /// The case-study content to render.
  final CaseStudy caseStudy;

  @override
  Widget build(BuildContext context) => EntityDisclosureCard(
    expandLabel: 'View case study details',
    collapseLabel: 'Hide case study details',
    preview: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValidatedText(
          field: caseStudy.title,
          style: AppTextStyles.contentTitle(context),
        ),
        const SizedBox(height: AppSpacing.size8),
        ValidatedText(
          field: caseStudy.summary,
          style: AppTextStyles.body(context),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        if (caseStudy.incidentCode != null) ...[
          const SizedBox(height: AppSpacing.size16),
          MetadataRow(
            items: [
              MetadataItemData(
                label: 'Incident code',
                value: caseStudy.incidentCode!,
                icon: Icons.confirmation_number_outlined,
              ),
            ],
          ),
        ],
      ],
    ),
    details: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ContentBlock(
          title: 'Incident overview',
          child: ExpandableValueTextBlock(
            field: caseStudy.incidentOverview,
            style: AppTextStyles.bodyCompact(context),
          ),
        ),
        const SizedBox(height: AppSpacing.size16),
        ContentBlock(
          title: 'Adversary objectives',
          child: ExpandableValueTextBlock(
            field: caseStudy.adversaryObjectives,
            style: AppTextStyles.bodyCompact(context),
          ),
        ),
        const SizedBox(height: AppSpacing.size16),
        ContentBlock(
          title: 'ATT&CK mapping',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SupportingText(text: 'Tactics'),
              const SizedBox(height: AppSpacing.size6),
              ValidatedBulletList(
                items: caseStudy.attackMapping.tactics,
                collectionFailure: collectionFailureOrNull(
                  caseStudy.attackMapping.tactics,
                  minLength: 1,
                ),
                style: AppTextStyles.bodyCompact(context),
              ),
              const SizedBox(height: AppSpacing.size12),
              const SupportingText(text: 'Techniques'),
              const SizedBox(height: AppSpacing.size6),
              ValidatedBulletList(
                items: caseStudy.attackMapping.techniques,
                collectionFailure: collectionFailureOrNull(
                  caseStudy.attackMapping.techniques,
                  minLength: 1,
                ),
                style: AppTextStyles.bodyCompact(context),
              ),
              const SizedBox(height: AppSpacing.size12),
              const SupportingText(text: 'Procedure examples'),
              const SizedBox(height: AppSpacing.size6),
              ValidatedBulletList(
                items: caseStudy.attackMapping.procedureExamples,
                collectionFailure: collectionFailureOrNull(
                  caseStudy.attackMapping.procedureExamples,
                  minLength: 1,
                ),
                style: AppTextStyles.bodyCompact(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.size16),
        ContentBlock(
          title: 'Defensive analysis',
          child: ExpandableValueTextBlock(
            field: caseStudy.defensiveAnalysis,
            style: AppTextStyles.bodyCompact(context),
          ),
        ),
        if (caseStudy.defensiveMapping != null) ...[
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'Defensive mapping',
            child: ExpandableValueTextBlock(
              field: caseStudy.defensiveMapping!,
              style: AppTextStyles.bodyCompact(context),
            ),
          ),
        ],
        if (caseStudy.atlasMapping != null) ...[
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'ATLAS mapping',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandableValueTextBlock(
                  field: caseStudy.atlasMapping!.summary,
                  style: AppTextStyles.bodyCompact(context),
                ),
                if (caseStudy
                    .atlasMapping!
                    .tacticsAndTechniques
                    .isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.size12),
                  const SupportingText(text: 'Tactics and techniques'),
                  const SizedBox(height: AppSpacing.size6),
                  ValidatedBulletList(
                    items: caseStudy.atlasMapping!.tacticsAndTechniques,
                    style: AppTextStyles.bodyCompact(context),
                  ),
                ],
                if (caseStudy.atlasMapping!.procedureExamples.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.size12),
                  const SupportingText(text: 'Procedure examples'),
                  const SizedBox(height: AppSpacing.size6),
                  ValidatedBulletList(
                    items: caseStudy.atlasMapping!.procedureExamples,
                    style: AppTextStyles.bodyCompact(context),
                  ),
                ],
              ],
            ),
          ),
        ],
        if (caseStudy.indicators != null) ...[
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'Indicators',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (caseStudy.indicators!.summary != null) ...[
                  ExpandableValueTextBlock(
                    field: caseStudy.indicators!.summary!,
                    style: AppTextStyles.bodyCompact(context),
                  ),
                  const SizedBox(height: AppSpacing.size8),
                ],
                ValidatedBulletList(
                  items: caseStudy.indicators!.items,
                  collectionFailure: collectionFailureOrNull(
                    caseStudy.indicators!.items,
                    minLength: 1,
                  ),
                  style: AppTextStyles.bodyCompact(context),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.size16),
        ContentBlock(
          title: 'Lessons learned',
          child: ValidatedBulletList(
            items: caseStudy.lessonsLearned,
            collectionFailure: collectionFailureOrNull(
              caseStudy.lessonsLearned,
              minLength: 1,
            ),
            style: AppTextStyles.bodyCompact(context),
          ),
        ),
        const SizedBox(height: AppSpacing.size16),
        ContentBlock(
          title: 'Reflection',
          child: ExpandableValueTextBlock(
            field: caseStudy.reflection,
            style: AppTextStyles.bodyCompact(context),
          ),
        ),
        const SizedBox(height: AppSpacing.size16),
        ContentBlock(
          title: 'References',
          child: LinkButtonList(
            links: caseStudy.references,
            collectionFailure: collectionFailureOrNull(
              caseStudy.references,
              minLength: 1,
            ),
          ),
        ),
      ],
    ),
  );
}
