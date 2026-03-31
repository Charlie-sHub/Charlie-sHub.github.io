import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:dartz/dartz.dart';

/// Validates that a string does not contain line breaks.
Either<ValueFailure<String>, String> validateStringSingleLine(String input) {
  if (input.contains('\n') || input.contains('\r')) {
    return left(ValueFailure.multilineString(failedValue: input));
  } else {
    return right(input);
  }
}
