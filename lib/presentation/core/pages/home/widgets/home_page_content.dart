import 'package:charlie_shub_portfolio/presentation/content/about/about_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/case_studies/case_studies_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/certifications/certifications_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/courses/courses_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/projects/projects_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/resume_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/home_page_constants.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/codersrank_supporting_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/profile_summary_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/initial_load_reveal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Main stacked home-page content shown below the wallpaper shell.
class HomePageContent extends StatelessWidget {
  /// Creates the home-page content widget.
  const HomePageContent({
    required this.includeInlineProfileSummary,
    required this.sectionKeys,
    required this.shouldPrepareCodersRank,
    super.key,
  });

  /// Whether the profile summary should be rendered inline above the sections.
  final bool includeInlineProfileSummary;

  /// Section anchor keys used for first-load scroll targeting.
  final Map<String, GlobalKey> sectionKeys;

  /// Shared signal used to prepare the optional CodersRank section.
  final ValueListenable<bool> shouldPrepareCodersRank;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (includeInlineProfileSummary) ...[
        const InitialLoadReveal(
          child: ProfileSummaryCard(key: homeProfileSummaryKey),
        ),
        const SizedBox(height: AppSpacing.size24),
      ],
      InitialLoadReveal(
        delay: homeSubtleMotionDelay,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KeyedSubtree(
              key: sectionKeys[aboutSectionId],
              child: const AboutSection(),
            ),
            const SizedBox(height: AppSpacing.size24),
            KeyedSubtree(
              key: sectionKeys[projectsSectionId],
              child: const ProjectsSection(),
            ),
            const SizedBox(height: AppSpacing.size24),
            KeyedSubtree(
              key: sectionKeys[certificationsSectionId],
              child: const CertificationsSection(),
            ),
            const SizedBox(height: AppSpacing.size24),
            KeyedSubtree(
              key: sectionKeys[caseStudiesSectionId],
              child: const CaseStudiesSection(),
            ),
            const SizedBox(height: AppSpacing.size24),
            KeyedSubtree(
              key: sectionKeys[coursesSectionId],
              child: const CoursesSection(),
            ),
            const SizedBox(height: AppSpacing.size24),
            KeyedSubtree(
              key: sectionKeys[resumeSectionId],
              child: const ResumeSection(),
            ),
            const SizedBox(height: AppSpacing.size24),
            KeyedSubtree(
              key: sectionKeys[codersRankSectionId],
              child: CodersRankSupportingSection(
                shouldPrepare: shouldPrepareCodersRank,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
