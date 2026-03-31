import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_max_length.dart';
import 'package:dartz/dartz.dart';

const _slugMaxLength = 64;

/// Validated snake_case slug used by structured content entries.
final class Slug extends ValueObject<String> {
  /// Creates a validated content slug.
  factory Slug(String input) => Slug._(
    validateStringMaxLength(input, maxLength: _slugMaxLength).fold(
      left,
      validateSlug,
    ),
  );

  const Slug._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
