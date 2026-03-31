// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_not_empty.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'validateStringNotEmpty',
    () {
      test(
        'returns the original value when the string has content',
        () {
          expect(validateStringNotEmpty('  PAMi  '), right('  PAMi  '));
        },
      );

      test(
        'fails for an empty string',
        () {
          expect(
            validateStringNotEmpty(''),
            left(const ValueFailure<String>.emptyString(failedValue: '')),
          );
        },
      );

      test(
        'fails for whitespace-only content',
        () {
          expect(
            validateStringNotEmpty(' \n\t '),
            left(const ValueFailure<String>.emptyString(failedValue: ' \n\t ')),
          );
        },
      );
    },
  );
}
