// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'AssetPath',
    () {
      test(
        'accepts repository media paths',
        () {
          final assetPath = AssetPath(
            'assets/media/content/projects/pami/hero.png',
          );

          expect(
            assetPath.value,
            right('assets/media/content/projects/pami/hero.png'),
          );
        },
      );

      test(
        'rejects paths outside the media tree',
        () {
          final assetPath = AssetPath(
            'assets/documents/certifications/comptia_security_plus.pdf',
          );

          expect(
            assetPath.value,
            left(
              const ValueFailure<String>.invalidAssetPath(
                failedValue:
                    'assets/documents/certifications/comptia_security_plus.pdf',
              ),
            ),
          );
        },
      );

      test(
        'rejects media paths that exceed the shared max length',
        () {
          final input = 'assets/media/${List.filled(148, 'a').join()}';
          final assetPath = AssetPath(input);

          expect(
            assetPath.value,
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
