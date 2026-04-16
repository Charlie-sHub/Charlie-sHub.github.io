import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entity_disclosure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/expandable_value_text_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_tile.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_asset_media_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Displays one fully rendered certification entry.
class CertificationCard extends StatelessWidget {
  /// Creates a certification card.
  const CertificationCard({
    required this.certification,
    super.key,
  });

  /// The certification content to render.
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

    return EntityDisclosureCard(
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: certification.title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.size8),
          ExpandableValueTextBlock(
            field: certification.summary,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.size16),
          MetadataRow(items: metadataItems),
          if (certification.badgeImagePath != null) ...[
            const SizedBox(height: AppSpacing.size16),
            ValidatedAssetMediaCard(
              path: certification.badgeImagePath!,
              labelBuilder: _buildBadgeLabel,
            ),
          ],
          if (certification.certificatePdfPath != null) ...[
            const SizedBox(height: AppSpacing.size16),
            ValidatedPdfPreviewTile(
              path: certification.certificatePdfPath!,
              title: 'Certificate PDF',
            ),
          ],
        ],
      ),
      details: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.size20),
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
          const SizedBox(height: AppSpacing.size16),
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
            const SizedBox(height: AppSpacing.size16),
            ContentBlock(
              title: 'Tools and frameworks',
              child: ValidatedBulletList(
                items: certification.toolsAndFrameworks,
                style: textTheme.bodyMedium,
              ),
            ),
          ],
          if (certification.proof.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.size16),
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
}
