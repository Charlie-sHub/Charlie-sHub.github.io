import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:dartz/dartz.dart';

/// Validates that a string does not exceed the provided maximum length.
Either<ValueFailure<String>, String> validateStringMaxLength(
  String input, {
  required int maxLength,
}) {
  if (input.length > maxLength) {
    return left(
      ValueFailure.stringExceedsLength(
        failedValue: input,
        maxLength: maxLength,
      ),
    );
  } else {
    return right(input);
  }
}
