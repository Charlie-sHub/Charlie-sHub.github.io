import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart'
    as content_title;
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/presentation/sections/courses_section.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/media_placeholder.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/field_failure_widget.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../application/content/content_test_entity_builders.dart';
import '../presentation_test_helpers.dart';

void main() {
  group(
    'CoursesSection',
    () {
      testWidgets(
        'renders valid course content with metadata, media, and links',
        (tester) async {
          final course = buildCourse().copyWith(
            badgeImagePath: AssetPath(
              'assets/media/content/courses/google_networking/badge.png',
            ),
            certificatePdfPath: DocumentPath(
              'assets/documents/courses/google_networking.pdf',
            ),
            keyTakeaways: <NonEmptyText>[
              NonEmptyText('Gained clearer networking vocabulary.'),
            ],
            proof: <LinkReference>[
              LinkReference(
                label: SingleLineText('Course proof'),
                url: UrlValue('https://example.com/course'),
              ),
            ],
          );

          await pumpWithContentState(
            tester,
            child: const CoursesSection(),
            state: _coursesState(
              right(<SectionItemLoad<Course>>[
                right(course),
              ]),
            ),
          );

          expect(find.text('Google Networking'), findsNWidgets(2));
          expect(find.text('A networking course.'), findsOneWidget);
          expect(find.text('Google'), findsNWidgets(2));
          expect(find.text('Course proof'), findsOneWidget);
          expect(find.byType(MediaPlaceholder), findsNWidgets(2));
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'switches visible detail content when another entry is selected',
        (tester) async {
          final firstCourse = buildCourse();
          final secondCourse = buildCourse().copyWith(
            title: content_title.Title('Google Security'),
            summary: NonEmptyText('A second course summary.'),
            courseDetails: buildCourse().courseDetails.copyWith(
              provider: SingleLineText('IBM'),
            ),
          );

          await pumpWithContentState(
            tester,
            child: const CoursesSection(),
            state: _coursesState(
              right(<SectionItemLoad<Course>>[
                right(firstCourse),
                right(secondCourse),
              ]),
            ),
          );

          expect(find.text('A networking course.'), findsOneWidget);
          expect(find.text('A second course summary.'), findsNothing);

          await tester.tap(
            find.byKey(const ValueKey<String>('entry-selector-item-1')),
          );
          await tester.pump();

          expect(find.text('A networking course.'), findsNothing);
          expect(find.text('A second course summary.'), findsOneWidget);
        },
      );

      testWidgets(
        'uses disclosure controls for long course summaries',
        (tester) async {
          final course = buildCourse().copyWith(
            summary: NonEmptyText(_buildLongText()),
          );

          await pumpWithContentState(
            tester,
            child: const CoursesSection(),
            state: _coursesState(
              right(<SectionItemLoad<Course>>[
                right(course),
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
        'renders a collection failure for missing required topics',
        (tester) async {
          final course = buildCourse().copyWith(
            topicsCovered: <NonEmptyText>[],
          );

          await pumpWithContentState(
            tester,
            child: const CoursesSection(),
            state: _coursesState(
              right(<SectionItemLoad<Course>>[
                right(course),
              ]),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.text('Networking fundamentals.'), findsNothing);
          expect(
            find.text('Supports infrastructure understanding.'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'defaults to the first available valid entry when earlier items fail',
        (tester) async {
          final course = buildCourse().copyWith(
            summary: NonEmptyText('Selected valid course.'),
          );

          await pumpWithContentState(
            tester,
            child: const CoursesSection(),
            state: _coursesState(
              right(<SectionItemLoad<Course>>[
                const Left<AppFailure, Course>(
                  AppFailure.assetNotFound(
                    path: 'assets/content/courses/first_missing.json',
                  ),
                ),
                right(course),
              ]),
            ),
          );

          expect(find.text('Unavailable course'), findsOneWidget);
          expect(find.byType(AppFailureCard), findsNothing);
          expect(find.text('Selected valid course.'), findsOneWidget);
        },
      );

      testWidgets(
        'renders selector label field failures explicitly',
        (tester) async {
          final course = buildCourse().copyWith(
            courseDetails: buildCourse().courseDetails.copyWith(
              provider: SingleLineText(''),
            ),
          );

          await pumpWithContentState(
            tester,
            child: const CoursesSection(),
            state: _coursesState(
              right(<SectionItemLoad<Course>>[
                right(course),
              ]),
            ),
          );

          expect(
            find.byType(FieldFailureWidget),
            findsAtLeastNWidgets(2),
          );
          expect(find.text('A networking course.'), findsOneWidget);
        },
      );

      testWidgets(
        'renders failure entries in the selector '
        'and shows details when selected',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const CoursesSection(),
            state: _coursesState(
              right(<SectionItemLoad<Course>>[
                right(buildCourse()),
                const Left<AppFailure, Course>(
                  AppFailure.assetNotFound(
                    path: 'assets/content/courses/missing.json',
                  ),
                ),
              ]),
            ),
          );

          expect(find.text('Google Networking'), findsNWidgets(2));
          expect(find.text('Unavailable course'), findsOneWidget);
          expect(find.byType(AppFailureCard), findsNothing);

          await tester.tap(
            find.byKey(const ValueKey<String>('entry-selector-item-1')),
          );
          await tester.pump();

          expect(find.text('Google Networking'), findsOneWidget);
          expect(find.byType(AppFailureCard), findsOneWidget);
          expect(
            find.textContaining('assets/content/courses/missing.json'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders a section-level failure without course content',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const CoursesSection(),
            state: _coursesState(
              left(
                const AppFailure.assetNotFound(
                  path: 'assets/content/courses/index.json',
                ),
              ),
            ),
          );

          expect(find.byType(AppFailureCard), findsOneWidget);
          expect(find.text('Google Networking'), findsNothing);
          expect(find.text('Courses section unavailable'), findsOneWidget);
        },
      );
    },
  );
}

ContentState _coursesState(
  MultiEntrySectionLoad<Course> coursesLoad,
) => ContentState.initial().copyWith(
  status: ContentStatus.loaded,
  coursesOption: some(coursesLoad),
);

String _buildLongText() => List<String>.filled(
  60,
  'This course summary is intentionally long for disclosure testing.',
).join(' ');
