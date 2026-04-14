import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/widgets/resume_education_list.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/widgets/resume_experience_list.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/widgets/resume_languages_card.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/widgets/resume_overview_card.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/widgets/resume_skill_groups.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Renders the resume section from loaded structured content.
class ResumeSection extends StatelessWidget {
  /// Creates a resume section.
  const ResumeSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    builder: (context, state) => SectionContainer(
      heading: const SectionHeadingText(
        text: 'Resume',
      ),
      children: _buildSectionChildren(state),
    ),
  );

  List<Widget> _buildSectionChildren(ContentState state) =>
      state.resumeOption.fold(
        () => <Widget>[
          SupportingText(
            text: state.status == ContentStatus.failure
                ? 'Resume content could not be requested because content '
                      'loading was interrupted.'
                : 'Loading resume content...',
          ),
        ],
        (sectionLoad) => sectionLoad.fold(
          (failure) => <Widget>[
            AppFailureCard(
              failure: failure,
              title: 'Resume section unavailable',
            ),
          ],
          (resume) => <Widget>[
            ResumeOverviewCard(resume: resume),
            const SizedBox(height: AppSpacing.size16),
            ContentBlock(
              title: 'Core skills',
              spacing: AppSpacing.size12,
              child: ResumeSkillGroups(
                skillGroups: resume.coreSkills,
              ),
            ),
            const SizedBox(height: AppSpacing.size16),
            ContentBlock(
              title: 'Professional experience',
              spacing: AppSpacing.size12,
              child: ResumeExperienceList(
                items: resume.professionalExperience,
              ),
            ),
            const SizedBox(height: AppSpacing.size16),
            ContentBlock(
              title: 'Education',
              spacing: AppSpacing.size12,
              child: ResumeEducationList(
                items: resume.education,
              ),
            ),
            const SizedBox(height: AppSpacing.size16),
            ContentBlock(
              title: 'Languages',
              spacing: AppSpacing.size12,
              child: ResumeLanguagesCard(languages: resume.languages),
            ),
          ],
        ),
      );
}
