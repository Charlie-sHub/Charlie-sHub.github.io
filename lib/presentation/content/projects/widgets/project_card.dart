import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entity_disclosure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/expandable_value_text_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/tag_chip_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_asset_media_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Displays one fully rendered project entry.
class ProjectCard extends StatelessWidget {
  /// Creates a project card.
  const ProjectCard({
    required this.project,
    super.key,
  });

  /// The project content to render.
  final Project project;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return EntityDisclosureCard(
      expandLabel: 'View project details',
      collapseLabel: 'Hide project details',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: project.title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.size8),
          ValidatedText(
            field: project.summary,
            style: textTheme.bodyLarge,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.size16),
          MetadataRow(
            items: [
              MetadataItemData(
                label: 'Started',
                value: project.startDate,
              ),
              if (project.endDate != null)
                MetadataItemData(
                  label: 'Ended',
                  value: project.endDate!,
                ),
            ],
          ),
          if (project.isOngoing) ...const [
            SizedBox(height: AppSpacing.size12),
            SupportingText(text: 'In progress'),
          ],
        ],
      ),
      details: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (project.heroImagePath != null) ...[
            ValidatedAssetMediaCard(
              path: project.heroImagePath!,
              labelBuilder: _buildHeroLabel,
              height: AppLayout.mediaHeroHeight,
            ),
            const SizedBox(height: AppSpacing.size20),
          ],
          if (project.galleryImagePaths.isNotEmpty) ...[
            ContentBlock(
              title: 'Selected screens',
              child: _ProjectGallery(
                galleryImagePaths: project.galleryImagePaths,
                heroImagePathValue: project.heroImagePath?.value.fold(
                  (_) => null,
                  (value) => value,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.size16),
          ],
          ContentBlock(
            title: 'Role and scope',
            child: ExpandableValueTextBlock(
              field: project.roleAndScope,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Product context',
            child: ExpandableValueTextBlock(
              field: project.productContext,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Stack',
            child: TagChipList(
              tags: project.stack,
              collectionFailure: collectionFailureOrNull(
                project.stack,
                minLength: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Implementation',
            child: ExpandableValueTextBlock(
              field: project.implementation,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Outcomes',
            child: ValidatedBulletList(
              items: project.outcomes,
              collectionFailure: collectionFailureOrNull(
                project.outcomes,
                minLength: 1,
              ),
              style: textTheme.bodyMedium,
            ),
          ),
          if (project.securityAndQuality != null) ...[
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Security and quality',
              child: ExpandableValueTextBlock(
                field: project.securityAndQuality!,
                style: textTheme.bodyMedium,
              ),
            ),
          ],
          if (project.lessons.isNotEmpty) ...[
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Lessons',
              child: ValidatedBulletList(
                items: project.lessons,
                style: textTheme.bodyMedium,
              ),
            ),
          ],
          if (project.links.isNotEmpty) ...[
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Links',
              child: ExternalLinkList(links: project.links),
            ),
          ],
        ],
      ),
    );
  }

  static String _buildHeroLabel(String value) =>
      'Project media available: ${value.split('/').last}';
}

class _ProjectGallery extends StatelessWidget {
  const _ProjectGallery({
    required this.galleryImagePaths,
    required this.heroImagePathValue,
  });

  final List<AssetPath> galleryImagePaths;
  final String? heroImagePathValue;

  @override
  Widget build(BuildContext context) {
    final galleryPaths = galleryImagePaths.where((path) {
      final pathValue = path.value.fold(
        (_) => null,
        (value) => value,
      );

      return pathValue != heroImagePathValue;
    }).toList();

    if (galleryPaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact =
            constraints.maxWidth < AppLayout.entrySelectorCompactBreakpoint;
        final itemWidth = isCompact
            ? constraints.maxWidth
            : (constraints.maxWidth - AppSpacing.size12) / 2;

        return Wrap(
          spacing: AppSpacing.size12,
          runSpacing: AppSpacing.size12,
          children: [
            for (final path in galleryPaths)
              SizedBox(
                width: itemWidth,
                child: ValidatedAssetMediaCard(
                  path: path,
                  labelBuilder: _buildGalleryLabel,
                  height: AppLayout.mediaGalleryItemHeight,
                ),
              ),
          ],
        );
      },
    );
  }

  static String _buildGalleryLabel(String value) =>
      'Project screen available: ${value.split('/').last}';
}
