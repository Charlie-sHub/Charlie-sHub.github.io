import 'dart:math' as math;

import 'package:charlie_shub_portfolio/presentation/content/about/about_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/case_studies/case_studies_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/certifications/certifications_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/courses/courses_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/projects/projects_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/resume_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/architecture_status_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/codersrank_supporting_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/home_intro_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/widget_showcase_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/profile_summary_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

const _appShellWallpaperAsset = 'assets/media/background.jpg';
const _profileSummaryKey = ValueKey<String>('home-profile-summary');

/// Home page that places the temporary showcase above the portfolio sections
/// during active theme verification.
class PortfolioHomePage extends StatelessWidget {
  /// Creates the portfolio home page.
  const PortfolioHomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    body: Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.canvas),
        const DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_appShellWallpaperAsset),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide =
                  constraints.maxWidth >= AppLayout.homeStickyProfileBreakpoint;

              if (isWide) {
                final frameWidth = math.min(
                  constraints.maxWidth,
                  AppLayout.maxHomeContentWidth +
                      AppSpacing.pagePadding.horizontal,
                );

                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: frameWidth,
                    height: constraints.maxHeight,
                    child: const Stack(
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left:
                                  AppSpacing.size24 +
                                  AppLayout.homeProfileSummaryWidth +
                                  AppLayout.homeProfileSummaryGap,
                              top: AppSpacing.size24,
                              right: AppSpacing.size24,
                              bottom: AppSpacing.size24,
                            ),
                            child: SingleChildScrollView(
                              child: _HomePageContent(
                                includeInlineProfileSummary: false,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: AppSpacing.size24,
                          top: AppSpacing.size24,
                          child: SizedBox(
                            key: _profileSummaryKey,
                            width: AppLayout.homeProfileSummaryWidth,
                            child: ProfileSummaryCard(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: AppSpacing.pagePadding,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppLayout.maxContentWidth,
                    ),
                    child: const _HomePageContent(
                      includeInlineProfileSummary: true,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent({
    required this.includeInlineProfileSummary,
  });

  final bool includeInlineProfileSummary;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _ShowcaseSegregationNotice(),
      const SizedBox(height: AppSpacing.size16),
      const WidgetShowcaseSection(),
      const SizedBox(height: AppSpacing.size24),
      if (includeInlineProfileSummary) ...[
        const ProfileSummaryCard(key: _profileSummaryKey),
        const SizedBox(height: AppSpacing.size24),
      ],
      const HomeIntroSection(),
      const SizedBox(height: AppSpacing.size24),
      const AboutSection(),
      const SizedBox(height: AppSpacing.size24),
      const ProjectsSection(),
      const SizedBox(height: AppSpacing.size24),
      const CertificationsSection(),
      const SizedBox(height: AppSpacing.size24),
      const CoursesSection(),
      const SizedBox(height: AppSpacing.size24),
      const CaseStudiesSection(),
      const SizedBox(height: AppSpacing.size24),
      const ResumeSection(),
      const SizedBox(height: AppSpacing.size24),
      const CodersRankSupportingSection(),
      const ArchitectureStatusSection(),
    ],
  );
}

class _ShowcaseSegregationNotice extends StatelessWidget {
  const _ShowcaseSegregationNotice();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ContentCard(
      variant: AppSurfaceVariant.section,
      padding: const EdgeInsets.all(AppSpacing.size16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.palette_outlined,
            color: colorScheme.secondary,
          ),
          const SizedBox(width: AppSpacing.size12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingText(text: 'Theme Verification Only'),
                SizedBox(height: AppSpacing.size4),
                SupportingText(
                  text:
                      'This temporary showcase is a developer-facing preview '
                      'surface. It is intentionally segregated from the real '
                      'portfolio hierarchy and should be removed before '
                      'deployment.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
