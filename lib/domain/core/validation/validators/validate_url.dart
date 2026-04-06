import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:dartz/dartz.dart';

/// Validates a public external URL used by portfolio content.
Either<ValueFailure<String>, String> validateUrl(String input) {
  if (input.contains('\n') || input.contains('\r')) {
    return left(ValueFailure.invalidUrl(failedValue: input));
  } else {
    final uri = Uri.tryParse(input);

    if (uri != null &&
        uri.isAbsolute &&
        uri.scheme == 'https' &&
        uri.host.isNotEmpty) {
      return right(input);
    } else {
      return left(ValueFailure.invalidUrl(failedValue: input));
    }
  }
}
