import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_experience_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/language_proficiency.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/resume_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_tile.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../application/content/content_test_entity_builders.dart';
import '../../core/presentation_test_helpers.dart';

void main() {
  group(
    'ResumeSection',
    () {
      testWidgets(
        'renders grouped resume content and valid language proficiency',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const ResumeSection(),
            state: _resumeState(
              right(buildResume()),
            ),
          );

          expect(find.text('Carlos Mendez'), findsOneWidget);
          expect(find.text('LinkedIn'), findsOneWidget);
          expect(find.text('Engineering'), findsOneWidget);
          expect(find.text('Software Engineer'), findsOneWidget);
          expect(find.text('Computer Science'), findsOneWidget);
          expect(find.text('English'), findsOneWidget);
          expect(find.text('C1'), findsOneWidget);
          expect(find.byType(PdfPreviewTile), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders a failure widget for unsupported language proficiency',
        (tester) async {
          final resume = buildResume().copyWith(
            languages: <ResumeLanguageItem>[
              ResumeLanguageItem(
                language: SingleLineText('English'),
                proficiency: LanguageProficiency.invalid,
              ),
            ],
          );

          await pumpWithContentState(
            tester,
            child: const ResumeSection(),
            state: _resumeState(
              right(resume),
            ),
          );

          expect(find.text('English'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.text('C1'), findsNothing);
        },
      );

      testWidgets(
        'renders collection failures for missing grouped skills',
        (tester) async {
          final resume = buildResume().copyWith(
            coreSkills: <ResumeSkillGroup>[],
          );

          await pumpWithContentState(
            tester,
            child: const ResumeSection(),
            state: _resumeState(
              right(resume),
            ),
          );

          expect(find.text('Core skills'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.text('Flutter'), findsNothing);
        },
      );

      testWidgets(
        'renders mixed valid content with timeline failures',
        (tester) async {
          final resume = buildResume().copyWith(
            professionalExperience: <ResumeExperienceItem>[
              ResumeExperienceItem(
                title: Title('Software Engineer'),
                organization: SingleLineText('Example Org'),
                location: SingleLineText('Remote'),
                startDate: YearMonth('2023-01'),
                isOngoing: false,
                highlights: <NonEmptyText>[
                  NonEmptyText('Built maintainable application flows.'),
                ],
              ),
            ],
          );

          await pumpWithContentState(
            tester,
            child: const ResumeSection(),
            state: _resumeState(
              right(resume),
            ),
          );

          expect(find.text('Carlos Mendez'), findsOneWidget);
          expect(find.text('Software Engineer'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(
            find.text('Built maintainable application flows.'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders a section-level failure without normal resume content',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const ResumeSection(),
            state: _resumeState(
              left(
                const AppFailure.assetNotFound(
                  path: 'assets/content/resume/index.json',
                ),
              ),
            ),
          );

          expect(find.byType(AppFailureCard), findsOneWidget);
          expect(find.text('Carlos Mendez'), findsNothing);
          expect(find.text('Resume section unavailable'), findsOneWidget);
        },
      );
    },
  );
}

ContentState _resumeState(
  Either<AppFailure, Resume> resumeLoad,
) => ContentState.initial().copyWith(
  status: ContentStatus.loaded,
  resumeOption: some(resumeLoad),
);
