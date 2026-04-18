import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/presentation/content/about/about_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../application/content/content_test_entity_builders.dart';
import '../../core/presentation_test_helpers.dart';

void main() {
  group(
    'AboutSection',
    () {
      testWidgets(
        'shows loading state and then renders about content',
        (tester) async {
          final cubit = await pumpWithContentState(
            tester,
            child: const AboutSection(),
            state: ContentState.initial().copyWith(
              status: ContentStatus.loading,
            ),
          );

          expect(find.text('Loading about content...'), findsOneWidget);

          cubit.emitState(
            _aboutState(
              right(buildAbout()),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('Loading about content...'), findsNothing);
          expect(find.text('About Me'), findsOneWidget);
          expect(find.text('Engineering background'), findsOneWidget);
          expect(find.text('Structured and pragmatic.'), findsOneWidget);
          expect(find.text('How I build software'), findsOneWidget);
          expect(find.text('Flutter'), findsNothing);
          expect(find.text('Selected skills and tools'), findsNothing);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders invalid narrative fields explicitly '
        'without showing hidden skills',
        (tester) async {
          final about = buildAbout().copyWith(
            developmentBackground: NonEmptyText(''),
          );

          await pumpWithContentState(
            tester,
            child: const AboutSection(),
            state: _aboutState(
              right(about),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(
            find.text('I build iteratively and document trade-offs.'),
            findsOneWidget,
          );
          expect(find.text('Selected skills and tools'), findsNothing);
          expect(find.text('Flutter'), findsNothing);
        },
      );

      testWidgets(
        'does not render hidden skill groups when they are missing',
        (tester) async {
          final about = buildAbout().copyWith(
            selectedSkillsAndTools: const [],
          );

          await pumpWithContentState(
            tester,
            child: const AboutSection(),
            state: _aboutState(
              right(about),
            ),
          );

          expect(find.text('Selected skills and tools'), findsNothing);
          expect(find.byType(FieldFailureWidget), findsNothing);
          expect(find.text('Flutter'), findsNothing);
          expect(
            find.text('How development and security connect'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders a section-level failure without normal about content',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const AboutSection(),
            state: _aboutState(
              left(
                const AppFailure.assetNotFound(
                  path: 'assets/content/about/index.json',
                ),
              ),
            ),
          );

          expect(find.byType(AppFailureCard), findsOneWidget);
          expect(find.text('About Me'), findsNothing);
          expect(find.text('About section unavailable'), findsOneWidget);
        },
      );
    },
  );
}

ContentState _aboutState(
  Either<AppFailure, About> aboutLoad,
) => ContentState.initial().copyWith(
  status: ContentStatus.loaded,
  aboutOption: some(aboutLoad),
);
