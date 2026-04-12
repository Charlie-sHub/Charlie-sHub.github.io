import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/expandable_text_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/tag_chip_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_placeholder.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
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
          _buildExpandableText(
            project.summary,
            textTheme.bodyLarge,
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
            child: _buildExpandableText(
              project.roleAndScope,
              textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Product context',
            child: _buildExpandableText(
              project.productContext,
              textTheme.bodyMedium,
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
            child: _buildExpandableText(
              project.implementation,
              textTheme.bodyMedium,
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
              child: _buildExpandableText(
                project.securityAndQuality!,
                textTheme.bodyMedium,
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
