import 'package:charlie_shub_portfolio/presentation/sections/about_section.dart';
import 'package:charlie_shub_portfolio/presentation/sections/architecture_status_section.dart';
import 'package:charlie_shub_portfolio/presentation/sections/case_studies_section.dart';
import 'package:charlie_shub_portfolio/presentation/sections/certifications_section.dart';
import 'package:charlie_shub_portfolio/presentation/sections/courses_section.dart';
import 'package:charlie_shub_portfolio/presentation/sections/home_intro_section.dart';
import 'package:charlie_shub_portfolio/presentation/sections/projects_section.dart';
import 'package:charlie_shub_portfolio/presentation/sections/resume_section.dart';
import 'package:charlie_shub_portfolio/presentation/sections/widget_showcase_section.dart';
import 'package:flutter/material.dart';

/// Home page that stacks the temporary showcase and portfolio sections.
class PortfolioHomePage extends StatelessWidget {
  /// Creates the portfolio home page.
  const PortfolioHomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetShowcaseSection(),
                SizedBox(height: 24),
                HomeIntroSection(),
                SizedBox(height: 24),
                AboutSection(),
                SizedBox(height: 24),
                ProjectsSection(),
                SizedBox(height: 24),
                CertificationsSection(),
                SizedBox(height: 24),
                CoursesSection(),
                SizedBox(height: 24),
                CaseStudiesSection(),
                SizedBox(height: 24),
                ResumeSection(),
                SizedBox(height: 24),
                ArchitectureStatusSection(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
