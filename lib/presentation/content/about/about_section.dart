import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/presentation/content/about/widgets/about_narrative_card.dart';
import 'package:charlie_shub_portfolio/presentation/content/about/widgets/about_skill_groups.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
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
            AboutNarrativeCard(about: about),
            const SizedBox(height: AppSpacing.size16),
            ContentBlock(
              title: 'Selected skills and tools',
              spacing: AppSpacing.size12,
              child: AboutSkillGroups(
                skillGroups: about.selectedSkillsAndTools,
              ),
            ),
          ],
        ),
      );
}
