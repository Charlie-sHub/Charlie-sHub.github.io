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
            find.byIcon(Icons.report_gmailerrorred_outlined),
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
        'renders the failure message and not unrelated content',
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
              'Asset was not found at assets/content/projects/index.json.',
            ),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.error_outline), findsOneWidget);
          expect(find.text('Unrelated content'), findsNothing);
        },
      );
    },
  );
}
