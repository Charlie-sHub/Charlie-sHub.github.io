import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:dartz/dartz.dart';

/// Validates that a string contains meaningful content after trimming.
Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  if (input.trim().isEmpty) {
    return left(ValueFailure.emptyString(failedValue: input));
  } else {
    return right(input);
  }
}
