import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/validators/validate_string_max_length.dart';
import 'package:dartz/dartz.dart';

const _documentPathMaxLength = 160;

/// Validated repository path under `assets/documents/`.
final class DocumentPath extends ValueObject<String> {
  /// Creates a document path value object with validation applied.
  factory DocumentPath(String input) => DocumentPath._(
    validateStringMaxLength(
      input,
      maxLength: _documentPathMaxLength,
    ).flatMap(validateDocumentPath),
  );

  const DocumentPath._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
