import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/contact/link_button_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entity_disclosure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/expandable_value_text_block.dart';
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
    final metadataItems = <MetadataItemData>[
      MetadataItemData(
        label: 'Earned',
        value: certification.earnedDate,
        icon: Icons.calendar_month_outlined,
      ),
      MetadataItemData(
        label: 'Issuer',
        value: certification.credentialDetails.issuer,
        icon: Icons.business_outlined,
      ),
      MetadataItemData(
        label: 'Level',
        value: certification.credentialDetails.level,
        icon: Icons.workspace_premium_outlined,
      ),
      if (certification.credentialDetails.platform != null)
        MetadataItemData(
          label: 'Platform',
          value: certification.credentialDetails.platform!,
          icon: Icons.computer_outlined,
        ),
    ];

    return EntityDisclosureCard(
      entityLabel: 'certification',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: certification.title,
            style: AppTextStyles.contentTitle(context),
          ),
          const SizedBox(height: AppSpacing.size8),
          ExpandableValueTextBlock(
            field: certification.summary,
            style: AppTextStyles.body(context),
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
              style: AppTextStyles.bodyCompact(context),
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
              style: AppTextStyles.bodyCompact(context),
            ),
          ),
          if (certification.toolsAndFrameworks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.size16),
            ContentBlock(
              title: 'Tools and frameworks',
              child: ValidatedBulletList(
                items: certification.toolsAndFrameworks,
                style: AppTextStyles.bodyCompact(context),
              ),
            ),
          ],
          if (certification.proof.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.size16),
            ContentBlock(
              title: 'Proof',
              child: LinkButtonList(
                links: certification.proof,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _buildBadgeLabel(String value) =>
      'Certification media available: ${value.split('/').last}';
}
