import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
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

/// Displays one fully rendered course entry.
class CourseCard extends StatelessWidget {
  /// Creates a course card.
  const CourseCard({
    required this.course,
    super.key,
  });

  /// The course content to render.
  final Course course;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final metadataItems = <MetadataItemData>[
      MetadataItemData(
        label: 'Provider',
        value: course.courseDetails.provider,
        icon: Icons.school_outlined,
      ),
      MetadataItemData(
        label: 'Platform',
        value: course.courseDetails.platform,
        icon: Icons.computer_outlined,
      ),
      MetadataItemData(
        label: 'Format',
        value: course.courseDetails.format,
        icon: Icons.view_agenda_outlined,
      ),
      MetadataItemData(
        label: 'Level',
        value: course.courseDetails.level,
        icon: Icons.workspace_premium_outlined,
      ),
      if (course.courseDetails.programContext != null)
        MetadataItemData(
          label: 'Program context',
          value: course.courseDetails.programContext!,
          icon: Icons.account_tree_outlined,
        ),
    ];

    return EntityDisclosureCard(
      expandLabel: 'View course details',
      collapseLabel: 'Hide course details',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: course.title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.size8),
          ValidatedText(
            field: course.summary,
            style: textTheme.bodyLarge,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.size16),
          MetadataRow(items: metadataItems),
        ],
      ),
      details: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentBlock(
            title: 'Overview',
            child: ExpandableValueTextBlock(
              field: course.summary,
              style: textTheme.bodyMedium,
            ),
          ),
          if (course.badgeImagePath != null) ...[
            const SizedBox(height: AppSpacing.size16),
            ValidatedAssetMediaCard(
              path: course.badgeImagePath!,
              labelBuilder: _buildBadgeLabel,
            ),
            const SizedBox(height: AppSpacing.size16),
          ],
          if (course.certificatePdfPath != null) ...[
            ValidatedPdfPreviewTile(
              path: course.certificatePdfPath!,
              title: 'Course PDF',
            ),
            const SizedBox(height: AppSpacing.size20),
          ] else ...[
            const SizedBox(height: AppSpacing.size16),
          ],
          ContentBlock(
            title: 'Topics covered',
            child: ValidatedBulletList(
              items: course.topicsCovered,
              collectionFailure: collectionFailureOrNull(
                course.topicsCovered,
                minLength: 1,
              ),
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'Relevance',
            child: ValidatedBulletList(
              items: course.relevance,
              collectionFailure: collectionFailureOrNull(
                course.relevance,
                minLength: 1,
              ),
              style: textTheme.bodyMedium,
            ),
          ),
          if (course.keyTakeaways.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.size16),
            ContentBlock(
              title: 'Key takeaways',
              child: ValidatedBulletList(
                items: course.keyTakeaways,
                style: textTheme.bodyMedium,
              ),
            ),
          ],
          if (course.proof.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.size16),
            ContentBlock(
              title: 'Proof',
              child: ExternalLinkList(links: course.proof),
            ),
          ],
        ],
      ),
    );
  }

  static String _buildBadgeLabel(String value) =>
      'Course media available: ${value.split('/').last}';
}
