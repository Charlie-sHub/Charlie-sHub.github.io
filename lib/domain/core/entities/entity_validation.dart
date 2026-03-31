import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
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
