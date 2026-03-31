import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:dartz/dartz.dart';

final _assetPathPattern = RegExp(r'^assets/media/[^\r\n]+$');

/// Validates a repository media path under `assets/media/`.
Either<ValueFailure<String>, String> validateAssetPath(String input) {
  if (_assetPathPattern.hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidAssetPath(failedValue: input));
  }
}
