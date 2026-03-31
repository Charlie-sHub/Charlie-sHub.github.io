import 'package:charlie_shub_portfolio/domain/core/entities/case_study_indicators.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'CaseStudyIndicators',
    () {
      test(
        'is valid with at least one indicator item',
        () {
          final indicators = CaseStudyIndicators(
            items: <NonEmptyText>[
              NonEmptyText('Scheduled task to reboot the system'),
            ],
          );

          expect(indicators.isValid, isTrue);
        },
      );

      test(
        'is invalid when items are empty',
        () {
          const indicators = CaseStudyIndicators(
            items: <NonEmptyText>[],
          );

          expect(indicators.isValid, isFalse);
          expect(indicators.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
