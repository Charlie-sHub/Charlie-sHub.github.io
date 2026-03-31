// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_asset_path.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'validateAssetPath',
    () {
      test(
        'accepts media asset paths used by content entries',
        () {
          expect(
            validateAssetPath('assets/media/content/projects/pami/hero.png'),
            right('assets/media/content/projects/pami/hero.png'),
          );
        },
      );

      test(
        'rejects document paths',
        () {
          expect(
            validateAssetPath('assets/documents/resume/carlos_mendez_dev.pdf'),
            left(
              const ValueFailure<String>.invalidAssetPath(
                failedValue: 'assets/documents/resume/carlos_mendez_dev.pdf',
              ),
            ),
          );
        },
      );

      test(
        'rejects non-repository paths',
        () {
          expect(
            validateAssetPath('hero.png'),
            left(
              const ValueFailure<String>.invalidAssetPath(
                failedValue: 'hero.png',
              ),
            ),
          );
        },
      );

      test(
        'rejects paths with line breaks',
        () {
          expect(
            validateAssetPath(
              'assets/media/content/projects/pami/hero.png\nnext',
            ),
            left(
              const ValueFailure<String>.invalidAssetPath(
                failedValue:
                    'assets/media/content/projects/pami/hero.png\nnext',
              ),
            ),
          );
        },
      );
    },
  );
}
