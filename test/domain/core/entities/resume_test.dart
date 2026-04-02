import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_education_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_experience_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/content_entry_type.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/language_proficiency.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Resume',
    () {
      test(
        'is valid for a schema-aligned resume shape',
        () {
          final resume = Resume(
            slug: Slug('resume'),
            sourcePath: SingleLineText('sources_of_truth/master_resume.md'),
            name: SingleLineText('Carlos Mendez'),
            location: SingleLineText('Bilbao, Spain'),
            summary: NonEmptyText(
              'Flutter software developer with 5+ years of experience',
            ),
            resumePdfPath: DocumentPath(
              'assets/documents/resume/carlos_mendez_dev.pdf',
            ),
            contactLinks: <LinkReference>[
              LinkReference(
                label: SingleLineText('GitHub'),
                url: UrlValue('https://github.com/Charlie-sHub'),
              ),
            ],
            coreSkills: <ResumeSkillGroup>[
              ResumeSkillGroup(
                label: SingleLineText('Languages & Frameworks'),
                items: <SingleLineText>[SingleLineText('Flutter')],
              ),
            ],
            professionalExperience: <ResumeExperienceItem>[
              ResumeExperienceItem(
                title: Title('Software Developer'),
                organization: SingleLineText('Media Mechanics'),
                location: SingleLineText('Halifax, Canada'),
                startDate: YearMonth('2021-06'),
                endDate: YearMonth('2024-10'),
                isOngoing: false,
                highlights: <NonEmptyText>[
                  NonEmptyText('Built Flutter applications'),
                ],
              ),
            ],
            education: <ResumeEducationItem>[
              ResumeEducationItem(
                title: Title(
                  'Higher Technician in Multiplatform Application Development',
                ),
                institution: SingleLineText('CIFP Tartanga'),
                location: SingleLineText('Erandio, Spain'),
                startDate: YearMonth('2018-09'),
                endDate: YearMonth('2020-05'),
              ),
            ],
            languages: <ResumeLanguageItem>[
              ResumeLanguageItem(
                language: SingleLineText('English'),
                proficiency: LanguageProficiency.c2,
              ),
            ],
          );

          expect(resume.isValid, isTrue);
          expect(resume.contentEntryType, ContentEntryType.resume);
        },
      );

      test(
        'is invalid when contact links are empty',
        () {
          final resume = Resume(
            slug: Slug('resume'),
            sourcePath: SingleLineText('sources_of_truth/master_resume.md'),
            name: SingleLineText('Carlos Mendez'),
            location: SingleLineText('Bilbao, Spain'),
            summary: NonEmptyText(
              'Flutter software developer with 5+ years of experience',
            ),
            contactLinks: const <LinkReference>[],
            coreSkills: <ResumeSkillGroup>[
              ResumeSkillGroup(
                label: SingleLineText('Languages & Frameworks'),
                items: <SingleLineText>[SingleLineText('Flutter')],
              ),
            ],
            professionalExperience: <ResumeExperienceItem>[
              ResumeExperienceItem(
                title: Title('Software Developer'),
                location: SingleLineText('Halifax, Canada'),
                startDate: YearMonth('2021-06'),
                endDate: YearMonth('2024-10'),
                isOngoing: false,
                highlights: <NonEmptyText>[
                  NonEmptyText('Built Flutter applications'),
                ],
              ),
            ],
            education: <ResumeEducationItem>[
              ResumeEducationItem(
                title: Title(
                  'Higher Technician in Multiplatform Application Development',
                ),
                institution: SingleLineText('CIFP Tartanga'),
                location: SingleLineText('Erandio, Spain'),
                startDate: YearMonth('2018-09'),
                endDate: YearMonth('2020-05'),
              ),
            ],
            languages: <ResumeLanguageItem>[
              ResumeLanguageItem(
                language: SingleLineText('English'),
                proficiency: LanguageProficiency.c2,
              ),
            ],
          );

          expect(resume.isValid, isFalse);
          expect(resume.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
