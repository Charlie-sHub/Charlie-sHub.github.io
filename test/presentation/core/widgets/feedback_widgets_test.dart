import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../presentation_test_helpers.dart';

void main() {
  group(
    'FieldFailureWidget',
    () {
      testWidgets(
        'renders failure content for an empty string failure',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const FieldFailureWidget(
                failure: ValueFailure<String>.emptyString(
                  failedValue: '',
                ),
              ),
            ),
          );

          expect(
            find.text('Invalid content: String must not be empty.'),
            findsOneWidget,
          );
          expect(
            find.byIcon(Icons.error_outline_rounded),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders different failure types without crashing',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const Column(
                children: [
                  FieldFailureWidget(
                    failure: ValueFailure<String>.invalidUrl(
                      failedValue: 'http://example.com',
                    ),
                  ),
                  FieldFailureWidget(
                    failure: ValueFailure<String>.invalidAssetPath(
                      failedValue: 'invalid/path.png',
                    ),
                  ),
                ],
              ),
            ),
          );

          expect(
            find.text(
              'Invalid content: URL must be a valid absolute https URL.',
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              'Invalid content: Asset path must start with assets/media/.',
            ),
            findsOneWidget,
          );
        },
      );
    },
  );

  group(
    'AppFailureCard',
    () {
      testWidgets(
        'renders neutral public copy instead of low-level failure details',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const AppFailureCard(
                failure: AppFailure.assetNotFound(
                  path: 'assets/content/projects/index.json',
                ),
                title: 'Projects section unavailable',
              ),
            ),
          );

          expect(
            find.text('Projects section unavailable'),
            findsOneWidget,
          );
          expect(
            find.text(
              'Some content for this section is unavailable right now.',
            ),
            findsOneWidget,
          );
          expect(
            find.text(
              'Asset was not found at assets/content/projects/index.json.',
            ),
            findsNothing,
          );
          expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
          expect(find.text('Unrelated content'), findsNothing);
        },
      );

      testWidgets(
        'omits parser and runtime detail from public failure copy',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const AppFailureCard(
                failure: AppFailure.contentLoadError(
                  path: 'assets/content/projects/index.json',
                  errorString: 'Unsupported JSON shape',
                ),
                title: 'Projects section unavailable',
              ),
            ),
          );

          expect(
            find.text('This content is temporarily unavailable.'),
            findsOneWidget,
          );
          expect(find.text('Unsupported JSON shape'), findsNothing);
          expect(
            find.text('assets/content/projects/index.json'),
            findsNothing,
          );
        },
      );
    },
  );
}
