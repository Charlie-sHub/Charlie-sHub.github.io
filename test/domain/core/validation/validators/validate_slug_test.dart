// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_slug.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'validateSlug',
    () {
      test(
        'accepts the snake_case slugs used by the content model',
        () {
          expect(
            validateSlug('google_cybersecurity'),
            right('google_cybersecurity'),
          );
        },
      );

      test(
        'rejects uppercase characters',
        () {
          expect(
            validateSlug('Google_cybersecurity'),
            left(
              const ValueFailure<String>.invalidSlug(
                failedValue: 'Google_cybersecurity',
              ),
            ),
          );
        },
      );

      test(
        'rejects hyphenated slugs',
        () {
          expect(
            validateSlug('google-cybersecurity'),
            left(
              const ValueFailure<String>.invalidSlug(
                failedValue: 'google-cybersecurity',
              ),
            ),
          );
        },
      );
    },
  );
}
