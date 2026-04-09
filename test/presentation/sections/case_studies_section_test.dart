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
import 'package:charlie_shub_portfolio/presentation/sections/case_studies_section.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/field_failure_widget.dart';
import 'package:dartz/dartz.dart';
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

          expect(find.text('Cutting Edge'), findsOneWidget);
          expect(find.text('A security case study.'), findsOneWidget);
          expect(find.text('CE-2024-001'), findsOneWidget);
          expect(find.text('ATLAS mapping'), findsOneWidget);
          expect(find.text('Indicators'), findsOneWidget);
          expect(find.text('Reference'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNothing);
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

          expect(find.text('Cutting Edge'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNWidgets(2));
          expect(find.text('Overview of the case.'), findsNothing);
        },
      );

      testWidgets(
        'renders item-level failures inline inside a successful section',
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
