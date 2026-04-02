import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_max_length.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_not_empty.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_single_line.dart';
import 'package:dartz/dartz.dart';

const _titleMaxLength = 128;

/// Validated single-line title text.
final class Title extends ValueObject<String> {
  /// Creates a title value object with validation applied.
  factory Title(String input) => Title._(
    validateStringNotEmpty(input)
        .flatMap(validateStringSingleLine)
        .flatMap(
          (singleLineValue) => validateStringMaxLength(
            singleLineValue,
            maxLength: _titleMaxLength,
          ),
        ),
  );

  const Title._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
