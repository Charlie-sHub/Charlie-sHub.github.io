import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_min_collection_length.dart';
import 'package:dartz/dartz.dart';

/// Returns the first non-null failure from a validation sequence.
Option<ValueFailure<dynamic>> firstFailureOrNone(
  Iterable<ValueFailure<dynamic>?> failures,
) {
  for (final failure in failures) {
    if (failure != null) {
      return some(failure);
    }
  }

  return none();
}

/// Returns a collection failure or `null` when the collection is valid.
ValueFailure<dynamic>? collectionFailureOrNull<T extends Iterable<Object?>>(
  T input, {
  required int minLength,
}) => validateMinCollectionLength(
  input,
  minLength: minLength,
).fold(id, (_) => null);

/// Returns a date-range failure when the end date precedes the start date.
ValueFailure<String>? dateRangeFailureOrNull({
  required YearMonth startDate,
  required YearMonth endDate,
}) {
  if (startDate.failureOrNull != null || endDate.failureOrNull != null) {
    return null;
  } else {
    final trustedStartDate = startDate.getOrCrash();
    final trustedEndDate = endDate.getOrCrash();

    if (trustedEndDate.compareTo(trustedStartDate) < 0) {
      return ValueFailure<String>.endDatePrecedesStartDate(
        failedValue: '$trustedStartDate->$trustedEndDate',
      );
    } else {
      return null;
    }
  }
}

/// Returns a timeline failure for entries that model ongoing versus completed
/// states with an optional end date.
ValueFailure<String>? ongoingTimelineFailureOrNull({
  required YearMonth startDate,
  required YearMonth? endDate,
  required bool isOngoing,
}) {
  if (startDate.failureOrNull != null || endDate?.failureOrNull != null) {
    return null;
  } else if (isOngoing) {
    if (endDate != null) {
      return ValueFailure<String>.ongoingTimelineHasEndDate(
        failedValue: '${startDate.getOrCrash()}->${endDate.getOrCrash()}',
      );
    } else {
      return null;
    }
  } else {
    if (endDate == null) {
      return ValueFailure<String>.completedTimelineMissingEndDate(
        failedValue: startDate.getOrCrash(),
      );
    } else {
      return dateRangeFailureOrNull(
        startDate: startDate,
        endDate: endDate,
      );
    }
  }
}
