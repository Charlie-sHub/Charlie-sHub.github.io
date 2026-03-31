// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_max_length.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'validateStringMaxLength',
    () {
      test(
        'accepts strings exactly at the max length boundary',
        () {
          final input = List.filled(160, 'a').join();

          expect(
            validateStringMaxLength(input, maxLength: 160),
            right(input),
          );
        },
      );

      test(
        'rejects strings that exceed the max length boundary',
        () {
          final input = List.filled(161, 'a').join();

          expect(
            validateStringMaxLength(input, maxLength: 160),
            left(
              ValueFailure<String>.stringExceedsLength(
                failedValue: input,
                maxLength: 160,
              ),
            ),
          );
        },
      );
    },
  );
}
