// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'YearMonth',
    () {
      test(
        'accepts the shared YYYY-MM schema format',
        () {
          final yearMonth = YearMonth('2026-03');

          expect(yearMonth.value, right('2026-03'));
        },
      );

      test(
        'rejects unsupported month values',
        () {
          final yearMonth = YearMonth('2026-13');

          expect(
            yearMonth.value,
            left(
              const ValueFailure<String>.invalidYearMonth(
                failedValue: '2026-13',
              ),
            ),
          );
        },
      );
    },
  );
}
