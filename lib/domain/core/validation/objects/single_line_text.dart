import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_max_length.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_not_empty.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_single_line.dart';
import 'package:dartz/dartz.dart';

const _singleLineTextMaxLength = 160;

/// Validated single-line text for labels and other line-oriented fields.
final class SingleLineText extends ValueObject<String> {
  /// Creates validated single-line text.
  factory SingleLineText(String input) => SingleLineText._(
    validateStringNotEmpty(input).fold(
      left,
      (value) => validateStringSingleLine(value).fold(
        left,
        (singleLineValue) => validateStringMaxLength(
          singleLineValue,
          maxLength: _singleLineTextMaxLength,
        ),
      ),
    ),
  );

  const SingleLineText._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
