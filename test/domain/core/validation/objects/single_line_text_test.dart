// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'SingleLineText',
    () {
      test(
        'accepts valid single-line text at the max length boundary',
        () {
          final input = List.filled(160, 'a').join();
          final text = SingleLineText(input);

          expect(text.value, right(input));
          expect(text.getOrCrash(), input);
        },
      );

      test(
        'rejects whitespace-only content',
        () {
          final text = SingleLineText('   ');

          expect(
            text.value,
            left(const ValueFailure<String>.emptyString(failedValue: '   ')),
          );
        },
      );

      test(
        'rejects multiline content',
        () {
          final text = SingleLineText('Architecture\nDiagram');

          expect(
            text.value,
            left(
              const ValueFailure<String>.multilineString(
                failedValue: 'Architecture\nDiagram',
              ),
            ),
          );
        },
      );

      test(
        'rejects text longer than the shared single-line limit',
        () {
          final input = List.filled(161, 'a').join();
          final text = SingleLineText(input);

          expect(
            text.value,
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
