import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_max_length.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_url.dart';
import 'package:dartz/dartz.dart';

const _urlMaxLength = 2048;

/// Validated absolute URL or URI used in public content references.
final class UrlValue extends ValueObject<String> {
  /// Creates a URL value object with validation applied.
  factory UrlValue(String input) => UrlValue._(
    validateStringMaxLength(
      input,
      maxLength: _urlMaxLength,
    ).flatMap(validateUrl),
  );

  const UrlValue._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
