import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'case_study_attack_mapping.freezed.dart';

/// ATT&CK mapping attached to a case study.
@freezed
abstract class CaseStudyAttackMapping with _$CaseStudyAttackMapping {
  /// Creates an ATT&CK mapping.
  const factory CaseStudyAttackMapping({
    required List<NonEmptyText> tactics,
    required List<NonEmptyText> techniques,
    required List<NonEmptyText> procedureExamples,
  }) = _CaseStudyAttackMapping;
  const CaseStudyAttackMapping._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        collectionFailureOrNull(tactics, minLength: 1),
        collectionFailureOrNull(techniques, minLength: 1),
        collectionFailureOrNull(procedureExamples, minLength: 1),
        ...tactics.map((item) => item.failureOrNull),
        ...techniques.map((item) => item.failureOrNull),
        ...procedureExamples.map((item) => item.failureOrNull),
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
