// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_single_line.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'validateStringSingleLine',
    () {
      test(
        'accepts single-line strings',
        () {
          expect(
            validateStringSingleLine('About Me'),
            right('About Me'),
          );
        },
      );

      test(
        'rejects strings with line breaks',
        () {
          expect(
            validateStringSingleLine('About\nMe'),
            left(
              const ValueFailure<String>.multilineString(
                failedValue: 'About\nMe',
              ),
            ),
          );
        },
      );
    },
  );
}
