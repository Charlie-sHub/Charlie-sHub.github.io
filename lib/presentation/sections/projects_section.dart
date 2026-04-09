import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/tag_chip_list.dart';
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

/// Renders the projects section from loaded structured content.
class ProjectsSection extends StatelessWidget {
  /// Creates a projects section.
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    builder: (context, state) => SectionContainer(
      heading: const SectionHeadingText(
        text: 'Projects',
      ),
      children: _buildSectionChildren(state),
    ),
  );

  List<Widget> _buildSectionChildren(
    ContentState state,
  ) => state.projectsOption.fold(
    () => <Widget>[
      SupportingText(
        text: state.status == ContentStatus.failure
            ? 'Projects could not be requested because content '
                  'loading was interrupted.'
            : 'Loading project content...',
      ),
    ],
    (sectionLoad) => sectionLoad.fold(
      (failure) => <Widget>[
        AppFailureCard(
          failure: failure,
          title: 'Projects section unavailable',
        ),
      ],
      (items) {
        if (items.isEmpty) {
          return const <Widget>[
            SupportingText(
              text: 'No project entries are available yet.',
            ),
          ];
        } else {
          return _buildSectionItems(items);
        }
      },
    ),
  );

  List<Widget> _buildSectionItems(List<SectionItemLoad<Project>> items) {
    final widgets = <Widget>[];

    for (var index = 0; index < items.length; index++) {
      widgets.add(_buildItem(items[index]));

      if (index < items.length - 1) {
        widgets.add(const SizedBox(height: 16));
      }
    }

    return widgets;
  }

  Widget _buildItem(SectionItemLoad<Project> item) => item.fold(
    (failure) => AppFailureCard(
      failure: failure,
      title: 'Project entry unavailable',
    ),
    (project) => _ProjectCard(
      project: project,
    ),
  );
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.project,
  });

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
          ValidatedText(
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
            child: ValidatedText(
              field: project.roleAndScope,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Product context',
            child: ValidatedText(
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
            child: ValidatedText(
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
              child: ValidatedText(
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
