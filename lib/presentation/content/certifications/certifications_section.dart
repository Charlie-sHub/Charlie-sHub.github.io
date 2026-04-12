import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entry_selector_labels.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entry_selector_panel.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/expandable_text_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_placeholder.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
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
          return <Widget>[
            EntrySelectorPanel<SectionItemLoad<Certification>>(
              entries: items,
              initialSelectedIndex: _preferredSelectedIndex(items),
              labelBuilder: _buildSelectorLabel,
              detailBuilder: (context, item) => _buildItem(item),
            ),
          ];
        }
      },
    ),
  );

  Widget _buildItem(SectionItemLoad<Certification> item) => item.fold(
    (failure) => AppFailureCard(
      failure: failure,
      title: 'Certification entry unavailable',
    ),
    (certification) => _CertificationCard(
      certification: certification,
    ),
  );

  Widget _buildSelectorLabel(
    BuildContext context,
    SectionItemLoad<Certification> item, {
    required bool isSelected,
  }) => item.fold(
    (_) => UnavailableEntrySelectorLabel(
      title: 'Unavailable certification',
      isSelected: isSelected,
    ),
    (certification) => EntrySelectorLabel(
      title: ValidatedText(
        field: certification.title,
        style: _selectorTitleStyle(context, isSelected),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: ValidatedText(
        field: certification.credentialDetails.issuer,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );

  int _preferredSelectedIndex(List<SectionItemLoad<Certification>> items) {
    final successfulIndex = items.indexWhere((item) => item.isRight());

    if (successfulIndex == -1) {
      return 0;
    }

    return successfulIndex;
  }

  TextStyle? _selectorTitleStyle(BuildContext context, bool isSelected) =>
      Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
          _buildExpandableText(
            certification.summary,
            textTheme.bodyLarge,
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

  Widget _buildExpandableText(
    ValueObject<String> field,
    TextStyle? style,
  ) => field.value.fold(
    (failure) => FieldFailureWidget(
      failure: failure,
    ),
    (value) => ExpandableTextBlock(
      text: value,
      style: style,
    ),
  );
}
