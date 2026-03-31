// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_url.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'validateUrl',
    () {
      test(
        'accepts absolute https URLs from the content files',
        () {
          expect(
            validateUrl('https://attack.mitre.org/software/S0368/'),
            right('https://attack.mitre.org/software/S0368/'),
          );
        },
      );

      test(
        'keeps URL validation broad enough for non-http absolute URIs',
        () {
          expect(
            validateUrl('mailto:hello@example.com'),
            right('mailto:hello@example.com'),
          );
        },
      );

      test(
        'rejects relative URLs',
        () {
          expect(
            validateUrl('/references/notpetya'),
            left(
              const ValueFailure<String>.invalidUrl(
                failedValue: '/references/notpetya',
              ),
            ),
          );
        },
      );

      test(
        'rejects malformed URLs',
        () {
          expect(
            validateUrl('not a url'),
            left(
              const ValueFailure<String>.invalidUrl(failedValue: 'not a url'),
            ),
          );
        },
      );

      test(
        'rejects URLs with line breaks',
        () {
          expect(
            validateUrl('https://attack.mitre.org/software/S0368/\nnext'),
            left(
              const ValueFailure<String>.invalidUrl(
                failedValue: 'https://attack.mitre.org/software/S0368/\nnext',
              ),
            ),
          );
        },
      );
    },
  );
}
