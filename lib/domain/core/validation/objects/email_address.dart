import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_email_address.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_max_length.dart';
import 'package:dartz/dartz.dart';

const _emailAddressMaxLength = 160;

/// Validated email address used for direct contact CTAs.
final class EmailAddress extends ValueObject<String> {
  /// Creates an email address value object with validation applied.
  factory EmailAddress(String input) => EmailAddress._(
    validateStringMaxLength(
      input,
      maxLength: _emailAddressMaxLength,
    ).flatMap(validateEmailAddress),
  );

  const EmailAddress._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
