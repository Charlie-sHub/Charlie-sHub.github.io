import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study_atlas_mapping.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study_indicators.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart'
    as content_title;
import 'package:charlie_shub_portfolio/presentation/sections/case_studies_section.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/field_failure_widget.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../application/content/content_test_entity_builders.dart';
import '../presentation_test_helpers.dart';

void main() {
  group(
    'CaseStudiesSection',
    () {
      testWidgets(
        'renders structured case study content blocks',
        (tester) async {
          final caseStudy = buildCaseStudy().copyWith(
            incidentCode: SingleLineText('CE-2024-001'),
            atlasMapping: CaseStudyAtlasMapping(
              summary: NonEmptyText('Maps attacker behavior to ATLAS.'),
              tacticsAndTechniques: <NonEmptyText>[
                NonEmptyText('Reconnaissance against model endpoints.'),
              ],
              procedureExamples: <NonEmptyText>[
                NonEmptyText('Prompt injection attempts.'),
              ],
            ),
            indicators: CaseStudyIndicators(
              summary: NonEmptyText('Key observable artifacts.'),
              items: <NonEmptyText>[
                NonEmptyText('Unexpected outbound connections.'),
              ],
            ),
          );

          await pumpWithContentState(
            tester,
            child: const CaseStudiesSection(),
            state: _caseStudiesState(
              right(<SectionItemLoad<CaseStudy>>[
                right(caseStudy),
              ]),
            ),
          );

          expect(find.text('Cutting Edge'), findsNWidgets(2));
          expect(find.text('A security case study.'), findsOneWidget);
          expect(find.text('CE-2024-001'), findsNWidgets(2));
          expect(find.text('ATLAS mapping'), findsOneWidget);
          expect(find.text('Indicators'), findsOneWidget);
          expect(find.text('Reference'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'switches visible detail content when another entry is selected',
        (tester) async {
          final firstCaseStudy = buildCaseStudy().copyWith(
            incidentCode: SingleLineText('CE-2024-001'),
          );
          final secondCaseStudy = buildCaseStudy().copyWith(
            title: content_title.Title('Solar Edge'),
            summary: NonEmptyText('A second security case study.'),
            incidentCode: SingleLineText('SE-2024-002'),
            incidentOverview: NonEmptyText('Overview of the second case.'),
          );

          await pumpWithContentState(
            tester,
            child: const CaseStudiesSection(),
            state: _caseStudiesState(
              right(<SectionItemLoad<CaseStudy>>[
                right(firstCaseStudy),
                right(secondCaseStudy),
              ]),
            ),
          );

          expect(find.text('Overview of the case.'), findsOneWidget);
          expect(find.text('Overview of the second case.'), findsNothing);

          await tester.tap(
            find.byKey(const ValueKey<String>('entry-selector-item-1')),
          );
          await tester.pump();

          expect(find.text('Overview of the case.'), findsNothing);
          expect(find.text('Overview of the second case.'), findsOneWidget);
        },
      );

      testWidgets(
        'uses disclosure controls for long case study summaries',
        (tester) async {
          final caseStudy = buildCaseStudy().copyWith(
            incidentCode: SingleLineText('CE-2024-001'),
            summary: NonEmptyText(_buildLongText()),
          );

          await pumpWithContentState(
            tester,
            child: const CaseStudiesSection(),
            state: _caseStudiesState(
              right(<SectionItemLoad<CaseStudy>>[
                right(caseStudy),
              ]),
            ),
            width: 360,
          );

          expect(find.text('Read more'), findsOneWidget);
          expect(find.text('Show less'), findsNothing);

          await tester.tap(find.text('Read more'));
          await tester.pump();

          expect(find.text('Show less'), findsOneWidget);
          expect(find.text('Read more'), findsNothing);
        },
      );

      testWidgets(
        'renders field and collection failures explicitly',
        (tester) async {
          final caseStudy = buildCaseStudy().copyWith(
            incidentOverview: NonEmptyText(''),
            references: <LinkReference>[],
          );

          await pumpWithContentState(
            tester,
            child: const CaseStudiesSection(),
            state: _caseStudiesState(
              right(<SectionItemLoad<CaseStudy>>[
                right(caseStudy),
              ]),
            ),
          );

          expect(find.text('Cutting Edge'), findsNWidgets(2));
          expect(find.byType(FieldFailureWidget), findsNWidgets(2));
          expect(find.text('Overview of the case.'), findsNothing);
        },
      );

      testWidgets(
        'defaults to the first available valid entry when earlier items fail',
        (tester) async {
          final caseStudy = buildCaseStudy().copyWith(
            incidentCode: SingleLineText('CE-2024-001'),
            summary: NonEmptyText('Selected valid case study.'),
          );

          await pumpWithContentState(
            tester,
            child: const CaseStudiesSection(),
            state: _caseStudiesState(
              right(<SectionItemLoad<CaseStudy>>[
                const Left<AppFailure, CaseStudy>(
                  AppFailure.assetNotFound(
                    path: 'assets/content/case_studies/first_missing.json',
                  ),
                ),
                right(caseStudy),
              ]),
            ),
          );

          expect(find.text('Unavailable case study'), findsOneWidget);
          expect(find.byType(AppFailureCard), findsNothing);
          expect(find.text('Selected valid case study.'), findsOneWidget);
        },
      );

      testWidgets(
        'renders selector label field failures explicitly',
        (tester) async {
          final caseStudy = buildCaseStudy().copyWith(
            title: content_title.Title(''),
          );

          await pumpWithContentState(
            tester,
            child: const CaseStudiesSection(),
            state: _caseStudiesState(
              right(<SectionItemLoad<CaseStudy>>[
                right(caseStudy),
              ]),
            ),
          );

          expect(
            find.byType(FieldFailureWidget),
            findsAtLeastNWidgets(2),
          );
          expect(find.text('A security case study.'), findsNWidgets(2));
        },
      );

      testWidgets(
        'renders failure entries in the selector '
        'and shows details when selected',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const CaseStudiesSection(),
            state: _caseStudiesState(
              right(<SectionItemLoad<CaseStudy>>[
                right(buildCaseStudy()),
                const Left<AppFailure, CaseStudy>(
                  AppFailure.assetNotFound(
                    path: 'assets/content/case_studies/missing.json',
                  ),
                ),
              ]),
            ),
          );

          expect(find.text('Cutting Edge'), findsNWidgets(2));
          expect(find.text('Unavailable case study'), findsOneWidget);
          expect(find.byType(AppFailureCard), findsNothing);

          await tester.tap(
            find.byKey(const ValueKey<String>('entry-selector-item-1')),
          );
          await tester.pump();

          expect(find.text('Cutting Edge'), findsOneWidget);
          expect(find.byType(AppFailureCard), findsOneWidget);
          expect(
            find.textContaining('assets/content/case_studies/missing.json'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders a section-level failure without case study content',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const CaseStudiesSection(),
            state: _caseStudiesState(
              left(
                const AppFailure.assetNotFound(
                  path: 'assets/content/case_studies/index.json',
                ),
              ),
            ),
          );

          expect(find.byType(AppFailureCard), findsOneWidget);
          expect(find.text('Cutting Edge'), findsNothing);
          expect(find.text('Case studies section unavailable'), findsOneWidget);
        },
      );
    },
  );
}

ContentState _caseStudiesState(
  MultiEntrySectionLoad<CaseStudy> caseStudiesLoad,
) => ContentState.initial().copyWith(
  status: ContentStatus.loaded,
  caseStudiesOption: some(caseStudiesLoad),
);

String _buildLongText() => List<String>.filled(
  60,
  'This case study summary is intentionally long for disclosure testing.',
).join(' ');
