import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:dartz/dartz.dart';

/// Validates that a collection meets the required minimum length.
Either<ValueFailure<T>, T>
validateMinCollectionLength<T extends Iterable<Object?>>(
  T input, {
  required int minLength,
}) {
  if (input.length < minLength) {
    return left(
      ValueFailure.collectionTooShort(
        failedValue: input,
        minLength: minLength,
      ),
    );
  } else {
    return right(input);
  }
}
