import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/validated_placeholder.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/validated_text.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/app_failure_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Renders the certifications section from loaded structured content.
class CertificationsSection extends StatelessWidget {
  /// Creates a certifications section.
  const CertificationsSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    builder: (context, state) => SectionContainer(
      heading: const SectionHeadingText(
        text: 'Certifications',
      ),
      children: _buildSectionChildren(state),
    ),
  );

  List<Widget> _buildSectionChildren(
    ContentState state,
  ) => state.certificationsOption.fold(
    () => <Widget>[
      SupportingText(
        text: state.status == ContentStatus.failure
            ? 'Certifications could not be requested because content '
                  'loading was interrupted.'
            : 'Loading certification content...',
      ),
    ],
    (sectionLoad) => sectionLoad.fold(
      (failure) => <Widget>[
        AppFailureCard(
          failure: failure,
          title: 'Certifications section unavailable',
        ),
      ],
      (items) {
        if (items.isEmpty) {
          return const <Widget>[
            SupportingText(
              text: 'No certification entries are available yet.',
            ),
          ];
        } else {
          return _buildSectionItems(items);
        }
      },
    ),
  );

  List<Widget> _buildSectionItems(List<SectionItemLoad<Certification>> items) {
    final widgets = <Widget>[];

    for (var index = 0; index < items.length; index++) {
      widgets.add(_buildItem(items[index]));

      if (index < items.length - 1) {
        widgets.add(const SizedBox(height: 16));
      }
    }

    return widgets;
  }

  Widget _buildItem(SectionItemLoad<Certification> item) => item.fold(
    (failure) => AppFailureCard(
      failure: failure,
      title: 'Certification entry unavailable',
    ),
    (certification) => _CertificationCard(
      certification: certification,
    ),
  );
}

class _CertificationCard extends StatelessWidget {
  const _CertificationCard({
    required this.certification,
  });

  final Certification certification;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final metadataItems = <MetadataItemData>[
      MetadataItemData(
        label: 'Earned',
        value: certification.earnedDate,
      ),
      MetadataItemData(
        label: 'Issuer',
        value: certification.credentialDetails.issuer,
      ),
      MetadataItemData(
        label: 'Level',
        value: certification.credentialDetails.level,
      ),
      if (certification.credentialDetails.platform != null)
        MetadataItemData(
          label: 'Platform',
          value: certification.credentialDetails.platform!,
        ),
    ];

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: certification.title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ValidatedText(
            field: certification.summary,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          MetadataRow(items: metadataItems),
          if (certification.badgeImagePath != null) ...[
            const SizedBox(height: 16),
            ValidatedPlaceholder(
              path: certification.badgeImagePath!,
              labelBuilder: _buildBadgeLabel,
            ),
          ],
          if (certification.certificatePdfPath != null) ...[
            const SizedBox(height: 16),
            ValidatedPlaceholder(
              path: certification.certificatePdfPath!,
              labelBuilder: _buildDocumentLabel,
              height: 140,
              icon: Icons.description_outlined,
            ),
          ],
          const SizedBox(height: 20),
          ContentBlock(
            title: 'Knowledge areas',
            child: ValidatedBulletList(
              items: certification.knowledgeAreas,
              collectionFailure: collectionFailureOrNull(
                certification.knowledgeAreas,
                minLength: 1,
              ),
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Learning outcomes',
            child: ValidatedBulletList(
              items: certification.learningOutcomes,
              collectionFailure: collectionFailureOrNull(
                certification.learningOutcomes,
                minLength: 1,
              ),
              style: textTheme.bodyMedium,
            ),
          ),
          if (certification.toolsAndFrameworks.isNotEmpty) ...[
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Tools and frameworks',
              child: ValidatedBulletList(
                items: certification.toolsAndFrameworks,
                style: textTheme.bodyMedium,
              ),
            ),
          ],
          if (certification.proof.isNotEmpty) ...[
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Proof',
              child: ExternalLinkList(links: certification.proof),
            ),
          ],
        ],
      ),
    );
  }

  static String _buildBadgeLabel(String value) =>
      'Certification media available: ${value.split('/').last}';

  static String _buildDocumentLabel(String value) =>
      'Certificate document available: ${value.split('/').last}';
}
