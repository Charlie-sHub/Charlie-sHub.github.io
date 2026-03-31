// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'UrlValue',
    () {
      test(
        'accepts absolute urls used in content references',
        () {
          final url = UrlValue('https://attack.mitre.org/software/S0368/');

          expect(url.value, right('https://attack.mitre.org/software/S0368/'));
        },
      );

      test(
        'keeps broader absolute uri support intact',
        () {
          final url = UrlValue('mailto:hello@example.com');

          expect(url.value, right('mailto:hello@example.com'));
        },
      );

      test(
        'rejects relative urls',
        () {
          final url = UrlValue('/references/notpetya');

          expect(
            url.value,
            left(
              const ValueFailure<String>.invalidUrl(
                failedValue: '/references/notpetya',
              ),
            ),
          );
        },
      );

      test(
        'rejects urls that exceed the shared max length',
        () {
          final input = 'https://example.com/${List.filled(2030, 'a').join()}';
          final url = UrlValue(input);

          expect(
            url.value,
            left(
              ValueFailure<String>.stringExceedsLength(
                failedValue: input,
                maxLength: 2048,
              ),
            ),
          );
        },
      );
    },
  );
}
