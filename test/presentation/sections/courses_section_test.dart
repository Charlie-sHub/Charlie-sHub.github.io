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
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/presentation/sections/courses_section.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/media_placeholder.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/field_failure_widget.dart';
import 'package:dartz/dartz.dart';
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

          expect(find.text('Google Networking'), findsOneWidget);
          expect(find.text('A networking course.'), findsOneWidget);
          expect(find.text('Google'), findsOneWidget);
          expect(find.text('Course proof'), findsOneWidget);
          expect(find.byType(MediaPlaceholder), findsNWidgets(2));
          expect(find.byType(FieldFailureWidget), findsNothing);
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
        'renders item-level failures inline inside a successful section',
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
