// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_document_path.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'validateDocumentPath',
    () {
      test(
        'accepts document asset paths used by content entries',
        () {
          expect(
            validateDocumentPath(
              'assets/documents/certifications/comptia_security_plus.pdf',
            ),
            right('assets/documents/certifications/comptia_security_plus.pdf'),
          );
        },
      );

      test(
        'rejects media asset paths',
        () {
          expect(
            validateDocumentPath(
              'assets/media/content/certifications/security_plus/badge.png',
            ),
            left(
              const ValueFailure<String>.invalidDocumentPath(
                failedValue:
                    'assets/media/content/certifications/security_plus/badge.png',
              ),
            ),
          );
        },
      );

      test(
        'rejects paths outside the documents tree',
        () {
          expect(
            validateDocumentPath('resume.pdf'),
            left(
              const ValueFailure<String>.invalidDocumentPath(
                failedValue: 'resume.pdf',
              ),
            ),
          );
        },
      );

      test(
        'rejects paths with line breaks',
        () {
          expect(
            validateDocumentPath(
              'assets/documents/resume/carlos_mendez_dev.pdf\nnext',
            ),
            left(
              const ValueFailure<String>.invalidDocumentPath(
                failedValue:
                    'assets/documents/resume/carlos_mendez_dev.pdf\nnext',
              ),
            ),
          );
        },
      );
    },
  );
}
