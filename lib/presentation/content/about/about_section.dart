import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/labeled_tag_group_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Renders the about section from loaded structured content.
class AboutSection extends StatelessWidget {
  /// Creates an about section.
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    builder: (context, state) => SectionContainer(
      heading: const SectionHeadingText(
        text: 'About',
      ),
      children: _buildSectionChildren(state),
    ),
  );

  List<Widget> _buildSectionChildren(ContentState state) =>
      state.aboutOption.fold(
        () => <Widget>[
          SupportingText(
            text: state.status == ContentStatus.failure
                ? 'About content could not be requested because content '
                      'loading was interrupted.'
                : 'Loading about content...',
          ),
        ],
        (sectionLoad) => sectionLoad.fold(
          (failure) => <Widget>[
            AppFailureCard(
              failure: failure,
              title: 'About section unavailable',
            ),
          ],
          (about) => <Widget>[
            _AboutNarrativeCard(about: about),
            const SizedBox(height: 16),
            ContentBlock(
              title: 'Selected skills and tools',
              spacing: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildSkillGroups(about),
              ),
            ),
          ],
        ),
      );

  List<Widget> _buildSkillGroups(About about) {
    final collectionFailure = collectionFailureOrNull(
      about.selectedSkillsAndTools,
      minLength: 1,
    );

    if (collectionFailure != null) {
      return <Widget>[
        FieldFailureWidget(
          failure: collectionFailure,
        ),
      ];
    }

    final widgets = <Widget>[];

    for (var index = 0; index < about.selectedSkillsAndTools.length; index++) {
      final group = about.selectedSkillsAndTools[index];
      widgets.add(
        LabeledTagGroupCard(
          label: group.label,
          items: group.items,
          collectionFailure: collectionFailureOrNull(
            group.items,
            minLength: 1,
          ),
        ),
      );

      if (index < about.selectedSkillsAndTools.length - 1) {
        widgets.add(const SizedBox(height: 12));
      }
    }

    return widgets;
  }
}

class _AboutNarrativeCard extends StatelessWidget {
  const _AboutNarrativeCard({
    required this.about,
  });

  final About about;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: about.title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Who I am professionally',
            child: ValidatedText(
              field: about.whoIAmProfessionally,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Current positioning',
            child: ValidatedText(
              field: about.currentPositioning,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Development background',
            child: ValidatedText(
              field: about.developmentBackground,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Security direction',
            child: ValidatedText(
              field: about.securityDirection,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Strengths and working style',
            child: ValidatedBulletList(
              items: about.strengthsAndWorkingStyle,
              collectionFailure: collectionFailureOrNull(
                about.strengthsAndWorkingStyle,
                minLength: 1,
              ),
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'How I build software',
            child: ValidatedText(
              field: about.howIBuildSoftware,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ContentBlock(
            title: 'How development and security connect',
            child: ValidatedText(
              field: about.howDevelopmentAndSecurityConnect,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
