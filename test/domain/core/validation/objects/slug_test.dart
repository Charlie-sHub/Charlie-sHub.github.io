// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Slug',
    () {
      test(
        'accepts the shared snake_case content slugs',
        () {
          final slug = Slug('google_cybersecurity');

          expect(slug.value, right('google_cybersecurity'));
          expect(slug.isValid(), isTrue);
        },
      );

      test(
        'rejects invalid slug shapes',
        () {
          final slug = Slug('Google-Cybersecurity');

          expect(
            slug.value,
            left(
              const ValueFailure<String>.invalidSlug(
                failedValue: 'Google-Cybersecurity',
              ),
            ),
          );
        },
      );

      test(
        'rejects slugs that exceed the shared max length',
        () {
          final input = '${List.filled(65, 'a').join()}_slug';
          final slug = Slug(input);

          expect(
            slug.value,
            left(
              ValueFailure<String>.stringExceedsLength(
                failedValue: input,
                maxLength: 64,
              ),
            ),
          );
        },
      );
    },
  );
}
