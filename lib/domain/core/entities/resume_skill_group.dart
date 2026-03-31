import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_skill_group.freezed.dart';

/// Group of related skills shown in the resume section.
@freezed
abstract class ResumeSkillGroup with _$ResumeSkillGroup {
  /// Creates a resume skill group.
  const factory ResumeSkillGroup({
    required SingleLineText label,
    required List<SingleLineText> items,
  }) = _ResumeSkillGroup;
  const ResumeSkillGroup._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        label.failureOrNull,
        collectionFailureOrNull(items, minLength: 1),
        ...items.map((item) => item.failureOrNull),
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
