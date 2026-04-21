import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:dartz/dartz.dart';

final _emailAddressPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

/// Validates a direct-contact email address used in public content.
Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  if (input.contains('\n') || input.contains('\r')) {
    return left(ValueFailure.invalidEmailAddress(failedValue: input));
  } else if (_emailAddressPattern.hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmailAddress(failedValue: input));
  }
}
