// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_year_month.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'validateYearMonth',
    () {
      test(
        'accepts the shared YYYY-MM date format',
        () {
          expect(validateYearMonth('2026-03'), right('2026-03'));
        },
      );

      test(
        'rejects slash-separated dates',
        () {
          expect(
            validateYearMonth('2026/03'),
            left(
              const ValueFailure<String>.invalidYearMonth(
                failedValue: '2026/03',
              ),
            ),
          );
        },
      );

      test(
        'rejects months outside the supported range',
        () {
          expect(
            validateYearMonth('2026-13'),
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
