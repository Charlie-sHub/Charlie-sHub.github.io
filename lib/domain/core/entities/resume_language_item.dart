import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/resume_language_proficiency.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_language_item.freezed.dart';

/// Language proficiency item attached to a resume entry.
@freezed
abstract class ResumeLanguageItem with _$ResumeLanguageItem {
  /// Creates a language item.
  const factory ResumeLanguageItem({
    required SingleLineText language,
    required ResumeLanguageProficiency proficiency,
  }) = _ResumeLanguageItem;
  const ResumeLanguageItem._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        language.failureOrNull,
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
