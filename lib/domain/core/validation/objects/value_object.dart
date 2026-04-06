import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

/// Base type for domain primitives that carry validation results.
@immutable
abstract class ValueObject<T> {
  /// Creates a value object.
  const ValueObject();

  /// Either the validation failure or the trusted value.
  Either<ValueFailure<T>, T> get value;

  /// Converts the current value into a generic success or failure result.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit => value.fold(
    left,
    (_) => right(unit),
  );

  /// Whether the wrapped value is valid.
  bool isValid() => value.isRight();

  /// Returns the trusted value or throws if validation failed.
  T getOrCrash() => value.fold(
    (failure) => throw UnexpectedValueError(failure),
    id,
  );

  /// Returns the failure when invalid, otherwise `null`.
  ValueFailure<T>? get failureOrNull => value.fold(
    id,
    (_) => null,
  );

  @override
  String toString() => value.fold(
    (failure) => failure.toString(),
    (value) => value.toString(),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other.runtimeType == runtimeType &&
          other is ValueObject &&
          other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value);
}

/// Error thrown when invalid data is accessed as trusted domain data.
final class UnexpectedValueError extends Error {
  /// Creates an unexpected value error.
  UnexpectedValueError(this.valueFailure);

  /// The validation failure that caused the crash.
  final ValueFailure<dynamic> valueFailure;

  @override
  String toString() => 'UnexpectedValueError($valueFailure)';
}
