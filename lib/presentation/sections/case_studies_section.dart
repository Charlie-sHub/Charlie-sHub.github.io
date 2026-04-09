import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/validated_text.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/app_failure_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Renders the case studies section from loaded structured content.
class CaseStudiesSection extends StatelessWidget {
  /// Creates a case studies section.
  const CaseStudiesSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    builder: (context, state) => SectionContainer(
      heading: const SectionHeadingText(
        text: 'Case Studies',
      ),
      children: _buildSectionChildren(state),
    ),
  );

  List<Widget> _buildSectionChildren(
    ContentState state,
  ) => state.caseStudiesOption.fold(
    () => <Widget>[
      SupportingText(
        text: state.status == ContentStatus.failure
            ? 'Case studies could not be requested because content '
                  'loading was interrupted.'
            : 'Loading case study content...',
      ),
    ],
    (sectionLoad) => sectionLoad.fold(
      (failure) => <Widget>[
        AppFailureCard(
          failure: failure,
          title: 'Case studies section unavailable',
        ),
      ],
      (items) {
        if (items.isEmpty) {
          return const <Widget>[
            SupportingText(
              text: 'No case studies are available yet.',
            ),
          ];
        } else {
          return _buildSectionItems(items);
        }
      },
    ),
  );

  List<Widget> _buildSectionItems(List<SectionItemLoad<CaseStudy>> items) {
    final widgets = <Widget>[];

    for (var index = 0; index < items.length; index++) {
      widgets.add(_buildItem(items[index]));

      if (index < items.length - 1) {
        widgets.add(const SizedBox(height: 16));
      }
    }

    return widgets;
  }

  Widget _buildItem(SectionItemLoad<CaseStudy> item) => item.fold(
    (failure) => AppFailureCard(
      failure: failure,
      title: 'Case study entry unavailable',
    ),
    (caseStudy) => _CaseStudyCard(caseStudy: caseStudy),
  );
}

class _CaseStudyCard extends StatelessWidget {
  const _CaseStudyCard({
    required this.caseStudy,
  });

  final CaseStudy caseStudy;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: caseStudy.title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ValidatedText(
            field: caseStudy.summary,
            style: textTheme.bodyLarge,
          ),
          if (caseStudy.incidentCode != null) ...[
            const SizedBox(height: 16),
            MetadataRow(
              items: [
                MetadataItemData(
                  label: 'Incident code',
                  value: caseStudy.incidentCode!,
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          ContentBlock(
            title: 'Incident overview',
            child: ValidatedText(
              field: caseStudy.incidentOverview,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Adversary objectives',
            child: ValidatedText(
              field: caseStudy.adversaryObjectives,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'ATT&CK mapping',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SupportingText(text: 'Tactics'),
                const SizedBox(height: 6),
                ValidatedBulletList(
                  items: caseStudy.attackMapping.tactics,
                  collectionFailure: collectionFailureOrNull(
                    caseStudy.attackMapping.tactics,
                    minLength: 1,
                  ),
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                const SupportingText(text: 'Techniques'),
                const SizedBox(height: 6),
                ValidatedBulletList(
                  items: caseStudy.attackMapping.techniques,
                  collectionFailure: collectionFailureOrNull(
                    caseStudy.attackMapping.techniques,
                    minLength: 1,
                  ),
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                const SupportingText(text: 'Procedure examples'),
                const SizedBox(height: 6),
                ValidatedBulletList(
                  items: caseStudy.attackMapping.procedureExamples,
                  collectionFailure: collectionFailureOrNull(
                    caseStudy.attackMapping.procedureExamples,
                    minLength: 1,
                  ),
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Defensive analysis',
            child: ValidatedText(
              field: caseStudy.defensiveAnalysis,
              style: textTheme.bodyMedium,
            ),
          ),
          if (caseStudy.defensiveMapping != null) ...[
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Defensive mapping',
              child: ValidatedText(
                field: caseStudy.defensiveMapping!,
                style: textTheme.bodyMedium,
              ),
            ),
          ],
          if (caseStudy.atlasMapping != null) ...[
            const SizedBox(height: 16),
            ContentBlock(
              title: 'ATLAS mapping',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValidatedText(
                    field: caseStudy.atlasMapping!.summary,
                    style: textTheme.bodyMedium,
                  ),
                  if (caseStudy
                      .atlasMapping!
                      .tacticsAndTechniques
                      .isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const SupportingText(text: 'Tactics and techniques'),
                    const SizedBox(height: 6),
                    ValidatedBulletList(
                      items: caseStudy.atlasMapping!.tacticsAndTechniques,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                  if (caseStudy.atlasMapping!.procedureExamples.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const SupportingText(text: 'Procedure examples'),
                    const SizedBox(height: 6),
                    ValidatedBulletList(
                      items: caseStudy.atlasMapping!.procedureExamples,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (caseStudy.indicators != null) ...[
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Indicators',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (caseStudy.indicators!.summary != null) ...[
                    ValidatedText(
                      field: caseStudy.indicators!.summary!,
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                  ],
                  ValidatedBulletList(
                    items: caseStudy.indicators!.items,
                    collectionFailure: collectionFailureOrNull(
                      caseStudy.indicators!.items,
                      minLength: 1,
                    ),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Lessons learned',
            child: ValidatedBulletList(
              items: caseStudy.lessonsLearned,
              collectionFailure: collectionFailureOrNull(
                caseStudy.lessonsLearned,
                minLength: 1,
              ),
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Reflection',
            child: ValidatedText(
              field: caseStudy.reflection,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'References',
            child: ExternalLinkList(
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
}
