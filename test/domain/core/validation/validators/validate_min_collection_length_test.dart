// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_min_collection_length.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'validateMinCollectionLength',
    () {
      test(
        'returns the original collection when it meets the minimum length',
        () {
          final result = validateMinCollectionLength(<String>[
            'Flutter',
          ], minLength: 1);

          expect(result.isRight(), isTrue);
          expect(result.getOrElse(() => <String>[]), <String>['Flutter']);
        },
      );

      test(
        'fails when the collection is shorter than required',
        () {
          expect(
            validateMinCollectionLength(<String>[], minLength: 1),
            left(
              const ValueFailure<List<String>>.collectionTooShort(
                failedValue: <String>[],
                minLength: 1,
              ),
            ),
          );
        },
      );

      test(
        'preserves the requested minimum length in the failure',
        () {
          expect(
            validateMinCollectionLength(<int>[1], minLength: 2),
            left(
              const ValueFailure<List<int>>.collectionTooShort(
                failedValue: <int>[1],
                minLength: 2,
              ),
            ),
          );
        },
      );
    },
  );
}
