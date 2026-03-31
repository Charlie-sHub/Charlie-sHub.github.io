// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Title',
    () {
      test(
        'accepts non-empty title content',
        () {
          final title = Title('About Me');

          expect(title.value, right('About Me'));
          expect(title.getOrCrash(), 'About Me');
        },
      );

      test(
        'rejects whitespace-only title content',
        () {
          final title = Title('   ');

          expect(
            title.value,
            left(const ValueFailure<String>.emptyString(failedValue: '   ')),
          );
        },
      );

      test(
        'rejects multiline title content',
        () {
          final title = Title('About\nMe');

          expect(
            title.value,
            left(
              const ValueFailure<String>.multilineString(
                failedValue: 'About\nMe',
              ),
            ),
          );
        },
      );

      test(
        'accepts title content at the max length boundary',
        () {
          final input = List.filled(128, 'a').join();
          final title = Title(input);

          expect(title.value, right(input));
        },
      );

      test(
        'rejects title content longer than the max length boundary',
        () {
          final input = List.filled(129, 'a').join();
          final title = Title(input);

          expect(
            title.value,
            left(
              ValueFailure<String>.stringExceedsLength(
                failedValue: input,
                maxLength: 128,
              ),
            ),
          );
        },
      );
    },
  );
}
