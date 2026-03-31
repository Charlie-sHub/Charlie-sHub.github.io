import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:dartz/dartz.dart';

final _slugPattern = RegExp(r'^[a-z0-9]+(?:_[a-z0-9]+)*$');

/// Validates the shared snake_case slug format.
Either<ValueFailure<String>, String> validateSlug(String input) {
  if (_slugPattern.hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidSlug(failedValue: input));
  }
}
