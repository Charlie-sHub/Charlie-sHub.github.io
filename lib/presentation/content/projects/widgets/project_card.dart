import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/expandable_value_text_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/tag_chip_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_placeholder.dart';
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

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: project.title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ExpandableValueTextBlock(
            field: project.summary,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
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
            SizedBox(height: 12),
            SupportingText(text: 'In progress'),
          ],
          if (project.heroImagePath != null) ...[
            const SizedBox(height: 16),
            ValidatedPlaceholder(
              path: project.heroImagePath!,
              labelBuilder: _buildHeroLabel,
            ),
          ],
          const SizedBox(height: 20),
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
