import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'firstFailureOrNone',
    () {
      test(
        'returns none when every failure candidate is null',
        () {
          final result = firstFailureOrNone(<ValueFailure<dynamic>?>[
            null,
            null,
          ]);

          expect(result, none<ValueFailure<dynamic>>());
        },
      );

      test(
        'returns the first available failure in order',
        () {
          const first = ValueFailure<String>.emptyString(failedValue: '');
          const second = ValueFailure<String>.invalidSlug(
            failedValue: 'bad-slug',
          );

          final result = firstFailureOrNone(<ValueFailure<dynamic>?>[
            null,
            second,
            first,
          ]);

          expect(result, some(second));
        },
      );
    },
  );

  group(
    'collectionFailureOrNull',
    () {
      test(
        'returns null when the collection meets the minimum length',
        () {
          final result = collectionFailureOrNull(<String>[
            'flutter',
          ], minLength: 1);

          expect(result, isNull);
        },
      );

      test(
        'returns the collection failure when the collection is too short',
        () {
          final result = collectionFailureOrNull(<String>[], minLength: 1);

          expect(
            result,
            const ValueFailure<List<String>>.collectionTooShort(
              failedValue: <String>[],
              minLength: 1,
            ),
          );
        },
      );
    },
  );
}
