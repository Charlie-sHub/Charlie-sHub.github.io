// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'DocumentPath',
    () {
      test(
        'accepts repository document paths',
        () {
          final documentPath = DocumentPath(
            'assets/documents/resume/carlos_mendez_dev.pdf',
          );

          expect(
            documentPath.value,
            right('assets/documents/resume/carlos_mendez_dev.pdf'),
          );
        },
      );

      test(
        'rejects media paths',
        () {
          final documentPath = DocumentPath(
            'assets/media/content/projects/pami/hero.png',
          );

          expect(
            documentPath.value,
            left(
              const ValueFailure<String>.invalidDocumentPath(
                failedValue: 'assets/media/content/projects/pami/hero.png',
              ),
            ),
          );
        },
      );

      test(
        'rejects document paths that exceed the shared max length',
        () {
          final input = 'assets/documents/${List.filled(144, 'a').join()}';
          final documentPath = DocumentPath(input);

          expect(
            documentPath.value,
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
