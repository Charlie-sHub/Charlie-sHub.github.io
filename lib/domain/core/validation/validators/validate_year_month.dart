import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:dartz/dartz.dart';

final _yearMonthPattern = RegExp(r'^[0-9]{4}-(0[1-9]|1[0-2])$');

/// Validates the shared `YYYY-MM` date format.
Either<ValueFailure<String>, String> validateYearMonth(String input) {
  if (_yearMonthPattern.hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidYearMonth(failedValue: input));
  }
}
