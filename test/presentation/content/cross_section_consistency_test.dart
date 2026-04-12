import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/presentation/content/about/about_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/case_studies/case_studies_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/certifications/certifications_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/courses/courses_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/projects/projects_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/resume_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/media_placeholder.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../application/content/content_test_entity_builders.dart';
import '../core/presentation_test_helpers.dart';

void main() {
  group(
    'Cross-section consistency',
    () {
      testWidgets(
        'renders long-form value failures consistently '
        'in about, projects, and case studies',
        (tester) async {
          final about = buildAbout().copyWith(
            howIBuildSoftware: NonEmptyText(''),
          );
          final project = buildProject().copyWith(
            roleAndScope: NonEmptyText(''),
          );
          final caseStudy = buildCaseStudy().copyWith(
            incidentOverview: NonEmptyText(''),
          );

          await pumpWithContentState(
            tester,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AboutSection(),
                ProjectsSection(),
                CaseStudiesSection(),
              ],
            ),
            state: ContentState.initial().copyWith(
              status: ContentStatus.loaded,
              aboutOption: some(right(about)),
              projectsOption: some(
                right(<SectionItemLoad<Project>>[
                  right(project),
                ]),
              ),
              caseStudiesOption: some(
                right(<SectionItemLoad<CaseStudy>>[
                  right(caseStudy),
                ]),
              ),
            ),
          );

          expect(find.text('About'), findsOneWidget);
          expect(find.text('Projects'), findsOneWidget);
          expect(find.text('Case Studies'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNWidgets(3));
          expect(find.text('Building maintainable software.'), findsOneWidget);
          expect(find.text('A portfolio proof project.'), findsOneWidget);
          expect(find.text('A security case study.'), findsNWidgets(2));
        },
      );

      testWidgets(
        'renders credential-style cards consistently '
        'across certifications and courses',
        (tester) async {
          final certification = buildCertification().copyWith(
            badgeImagePath: AssetPath(
              'assets/media/content/certifications/security_plus/badge.png',
            ),
            certificatePdfPath: DocumentPath(
              'assets/documents/certifications/security_plus.pdf',
            ),
            proof: <LinkReference>[
              LinkReference(
                label: SingleLineText('Credential proof'),
                url: UrlValue('https://example.com/certification'),
              ),
            ],
          );
          final course = buildCourse().copyWith(
            badgeImagePath: AssetPath(
              'assets/media/content/courses/google_networking/badge.png',
            ),
            certificatePdfPath: DocumentPath(
              'assets/documents/courses/google_networking.pdf',
            ),
            proof: <LinkReference>[
              LinkReference(
                label: SingleLineText('Course proof'),
                url: UrlValue('https://example.com/course'),
              ),
            ],
          );

          await pumpWithContentState(
            tester,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CertificationsSection(),
                CoursesSection(),
              ],
            ),
            state: ContentState.initial().copyWith(
              status: ContentStatus.loaded,
              certificationsOption: some(
                right(<SectionItemLoad<Certification>>[
                  right(certification),
                ]),
              ),
              coursesOption: some(
                right(<SectionItemLoad<Course>>[
                  right(course),
                ]),
              ),
            ),
          );

          expect(find.text('Security+'), findsNWidgets(2));
          expect(find.text('Google Networking'), findsNWidgets(2));
          expect(find.text('CompTIA'), findsNWidgets(2));
          expect(find.text('Google'), findsNWidgets(2));
          expect(find.text('Credential proof'), findsOneWidget);
          expect(find.text('Course proof'), findsOneWidget);
          expect(find.byType(MediaPlaceholder), findsNWidgets(4));
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders grouped skills consistently in about '
        'and resume, including invalid entries',
        (tester) async {
          final about = buildAbout().copyWith(
            selectedSkillsAndTools: <AboutSkillGroup>[
              AboutSkillGroup(
                label: SingleLineText('Core'),
                items: <SingleLineText>[
                  SingleLineText(''),
                ],
              ),
            ],
          );
          final resume = buildResume().copyWith(
            coreSkills: <ResumeSkillGroup>[
              ResumeSkillGroup(
                label: SingleLineText(''),
                items: <SingleLineText>[
                  SingleLineText('Flutter'),
                ],
              ),
            ],
          );

          await pumpWithContentState(
            tester,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AboutSection(),
                ResumeSection(),
              ],
            ),
            state: ContentState.initial().copyWith(
              status: ContentStatus.loaded,
              aboutOption: some(right(about)),
              resumeOption: some(right(resume)),
            ),
          );

          expect(find.text('Selected skills and tools'), findsOneWidget);
          expect(find.text('Core skills'), findsOneWidget);
          expect(find.text('Flutter'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNWidgets(2));
        },
      );
    },
  );
}
