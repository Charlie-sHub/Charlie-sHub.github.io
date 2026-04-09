import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
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

/// Renders the courses section from loaded structured content.
class CoursesSection extends StatelessWidget {
  /// Creates a courses section.
  const CoursesSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    builder: (context, state) => SectionContainer(
      heading: const SectionHeadingText(
        text: 'Courses',
      ),
      children: _buildSectionChildren(state),
    ),
  );

  List<Widget> _buildSectionChildren(
    ContentState state,
  ) => state.coursesOption.fold(
    () => <Widget>[
      SupportingText(
        text: state.status == ContentStatus.failure
            ? 'Courses could not be requested because content loading '
                  'was interrupted.'
            : 'Loading course content...',
      ),
    ],
    (sectionLoad) => sectionLoad.fold(
      (failure) => <Widget>[
        AppFailureCard(
          failure: failure,
          title: 'Courses section unavailable',
        ),
      ],
      (items) {
        if (items.isEmpty) {
          return const <Widget>[
            SupportingText(
              text: 'No course entries are available yet.',
            ),
          ];
        } else {
          return _buildSectionItems(items);
        }
      },
    ),
  );

  List<Widget> _buildSectionItems(List<SectionItemLoad<Course>> items) {
    final widgets = <Widget>[];

    for (var index = 0; index < items.length; index++) {
      widgets.add(_buildItem(items[index]));

      if (index < items.length - 1) {
        widgets.add(const SizedBox(height: 16));
      }
    }

    return widgets;
  }

  Widget _buildItem(SectionItemLoad<Course> item) => item.fold(
    (failure) => AppFailureCard(
      failure: failure,
      title: 'Course entry unavailable',
    ),
    (course) => _CourseCard(course: course),
  );
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final metadataItems = <MetadataItemData>[
      MetadataItemData(
        label: 'Provider',
        value: course.courseDetails.provider,
      ),
      MetadataItemData(
        label: 'Platform',
        value: course.courseDetails.platform,
      ),
      MetadataItemData(
        label: 'Format',
        value: course.courseDetails.format,
      ),
      MetadataItemData(
        label: 'Level',
        value: course.courseDetails.level,
      ),
      if (course.courseDetails.programContext != null)
        MetadataItemData(
          label: 'Program context',
          value: course.courseDetails.programContext!,
        ),
    ];

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: course.title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ValidatedText(
            field: course.summary,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          MetadataRow(items: metadataItems),
          if (course.badgeImagePath != null) ...[
            const SizedBox(height: 16),
            ValidatedPlaceholder(
              path: course.badgeImagePath!,
              labelBuilder: _buildBadgeLabel,
            ),
          ],
          if (course.certificatePdfPath != null) ...[
            const SizedBox(height: 16),
            ValidatedPlaceholder(
              path: course.certificatePdfPath!,
              labelBuilder: _buildDocumentLabel,
              height: 140,
              icon: Icons.description_outlined,
            ),
          ],
          const SizedBox(height: 20),
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
          const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Key takeaways',
              child: ValidatedBulletList(
                items: course.keyTakeaways,
                style: textTheme.bodyMedium,
              ),
            ),
          ],
          if (course.proof.isNotEmpty) ...[
            const SizedBox(height: 16),
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

  static String _buildDocumentLabel(String value) =>
      'Course document available: ${value.split('/').last}';
}
