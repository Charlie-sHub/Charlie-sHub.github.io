import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:dartz/dartz.dart';

final _documentPathPattern = RegExp(r'^assets/documents/[^\r\n]+$');

/// Validates a repository document path under `assets/documents/`.
Either<ValueFailure<String>, String> validateDocumentPath(String input) {
  if (_documentPathPattern.hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidDocumentPath(failedValue: input));
  }
}
