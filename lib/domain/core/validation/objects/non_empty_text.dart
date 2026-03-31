import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_max_length.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_not_empty.dart';
import 'package:dartz/dartz.dart';

const _nonEmptyTextMaxLength = 12000;

/// Validated long-form text that may remain multiline.
final class NonEmptyText extends ValueObject<String> {
  /// Creates validated long-form text.
  factory NonEmptyText(String input) => NonEmptyText._(
    validateStringNotEmpty(input).fold(
      left,
      (value) => validateStringMaxLength(
        value,
        maxLength: _nonEmptyTextMaxLength,
      ),
    ),
  );

  const NonEmptyText._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
