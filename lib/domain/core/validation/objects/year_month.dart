import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_year_month.dart';
import 'package:dartz/dartz.dart';

/// Validated `YYYY-MM` date value.
final class YearMonth extends ValueObject<String> {
  /// Creates a `YYYY-MM` value object with validation applied.
  factory YearMonth(String input) => YearMonth._(validateYearMonth(input));

  const YearMonth._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
