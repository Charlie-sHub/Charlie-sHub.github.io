import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
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

  group(
    'dateRangeFailureOrNull',
    () {
      test(
        'returns null when the end date is on or after the start date',
        () {
          final result = dateRangeFailureOrNull(
            startDate: YearMonth('2025-01'),
            endDate: YearMonth('2025-02'),
          );

          expect(result, isNull);
        },
      );

      test(
        'returns a failure when the end date is earlier than the start date',
        () {
          final result = dateRangeFailureOrNull(
            startDate: YearMonth('2025-03'),
            endDate: YearMonth('2025-02'),
          );

          expect(
            result,
            const ValueFailure<String>.endDatePrecedesStartDate(
              failedValue: '2025-03->2025-02',
            ),
          );
        },
      );
    },
  );

  group(
    'ongoingTimelineFailureOrNull',
    () {
      test(
        'returns null for an ongoing entry with no end date',
        () {
          final result = ongoingTimelineFailureOrNull(
            startDate: YearMonth('2025-01'),
            endDate: null,
            isOngoing: true,
          );

          expect(result, isNull);
        },
      );

      test(
        'returns a failure when an ongoing entry defines an end date',
        () {
          final result = ongoingTimelineFailureOrNull(
            startDate: YearMonth('2025-01'),
            endDate: YearMonth('2025-02'),
            isOngoing: true,
          );

          expect(
            result,
            const ValueFailure<String>.ongoingTimelineHasEndDate(
              failedValue: '2025-01->2025-02',
            ),
          );
        },
      );

      test(
        'returns a failure when a completed entry is missing an end date',
        () {
          final result = ongoingTimelineFailureOrNull(
            startDate: YearMonth('2025-01'),
            endDate: null,
            isOngoing: false,
          );

          expect(
            result,
            const ValueFailure<String>.completedTimelineMissingEndDate(
              failedValue: '2025-01',
            ),
          );
        },
      );

      test(
        'returns a date-range failure for completed entries with inverted '
        'dates',
        () {
          final result = ongoingTimelineFailureOrNull(
            startDate: YearMonth('2025-03'),
            endDate: YearMonth('2025-02'),
            isOngoing: false,
          );

          expect(
            result,
            const ValueFailure<String>.endDatePrecedesStartDate(
              failedValue: '2025-03->2025-02',
            ),
          );
        },
      );
    },
  );
}
