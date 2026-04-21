import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/presentation/content/projects/widgets/project_image_carousel.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entity_disclosure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/expandable_value_text_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/link_button_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/tag_chip_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
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
  Widget build(BuildContext context) => EntityDisclosureCard(
    entityLabel: 'project',
    preview: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValidatedText(
          field: project.title,
          style: AppTextStyles.contentTitle(context),
        ),
        const SizedBox(height: AppSpacing.size8),
        ValidatedText(
          field: project.summary,
          style: AppTextStyles.body(context),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.size16),
        MetadataRow(
          items: [
            MetadataItemData(
              label: 'Started',
              value: project.startDate,
              icon: Icons.calendar_month_outlined,
            ),
            if (project.endDate != null)
              MetadataItemData(
                label: 'Ended',
                value: project.endDate!,
                icon: Icons.event_available_outlined,
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
        if (_projectImagePaths.isNotEmpty) ...[
          ContentBlock(
            title: 'Project images',
            child: ProjectImageCarousel(imagePaths: _projectImagePaths),
          ),
          const SizedBox(height: AppSpacing.size16),
        ],
        ContentBlock(
          title: 'Role and scope',
          child: ExpandableValueTextBlock(
            field: project.roleAndScope,
            style: AppTextStyles.bodyCompact(context),
          ),
        ),
        const SizedBox(height: AppSpacing.size16),
        ContentBlock(
          title: 'Product context',
          child: ExpandableValueTextBlock(
            field: project.productContext,
            style: AppTextStyles.bodyCompact(context),
          ),
        ),
        const SizedBox(height: AppSpacing.size16),
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
        const SizedBox(height: AppSpacing.size16),
        ContentBlock(
          title: 'Implementation',
          child: ExpandableValueTextBlock(
            field: project.implementation,
            style: AppTextStyles.bodyCompact(context),
          ),
        ),
        const SizedBox(height: AppSpacing.size16),
        ContentBlock(
          title: 'Outcomes',
          child: ValidatedBulletList(
            items: project.outcomes,
            collectionFailure: collectionFailureOrNull(
              project.outcomes,
              minLength: 1,
            ),
            style: AppTextStyles.bodyCompact(context),
          ),
        ),
        if (project.securityAndQuality != null) ...[
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'Security and quality',
            child: ExpandableValueTextBlock(
              field: project.securityAndQuality!,
              style: AppTextStyles.bodyCompact(context),
            ),
          ),
        ],
        if (project.lessons.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'Lessons',
            child: ValidatedBulletList(
              items: project.lessons,
              style: AppTextStyles.bodyCompact(context),
            ),
          ),
        ],
        if (project.links.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'Links',
            child: LinkButtonList(links: project.links),
          ),
        ],
      ],
    ),
  );

  List<AssetPath> get _projectImagePaths {
    final imagePaths = <AssetPath>[];
    final seenValues = <String>{};

    void addImagePath(AssetPath path) {
      final value = path.value.fold(
        (_) => null,
        (imagePathValue) => imagePathValue,
      );

      if (value == null) {
        imagePaths.add(path);

        return;
      }

      if (seenValues.add(value)) {
        imagePaths.add(path);
      }
    }

    final heroImagePath = project.heroImagePath;
    if (heroImagePath != null) {
      addImagePath(heroImagePath);
    }

    project.galleryImagePaths.forEach(addImagePath);

    return imagePaths;
  }
}
