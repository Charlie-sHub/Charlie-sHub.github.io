// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'NonEmptyText',
    () {
      test(
        'accepts non-empty text content',
        () {
          final text = NonEmptyText('Structured planning');

          expect(text.value, right('Structured planning'));
          expect(text.getOrCrash(), 'Structured planning');
        },
      );

      test(
        'accepts multiline long-form text content',
        () {
          final text = NonEmptyText(
            'Structured planning before implementation.\n\n'
            'Careful execution after decisions are clear.',
          );

          expect(
            text.value,
            right(
              'Structured planning before implementation.\n\n'
              'Careful execution after decisions are clear.',
            ),
          );
        },
      );

      test(
        'rejects whitespace-only content',
        () {
          final text = NonEmptyText('   ');

          expect(
            text.value,
            left(const ValueFailure<String>.emptyString(failedValue: '   ')),
          );
        },
      );

      test(
        'rejects text longer than the shared long-form limit',
        () {
          final input = List.filled(12001, 'a').join();
          final text = NonEmptyText(input);

          expect(
            text.value,
            left(
              ValueFailure<String>.stringExceedsLength(
                failedValue: input,
                maxLength: 12000,
              ),
            ),
          );
        },
      );
    },
  );
}
