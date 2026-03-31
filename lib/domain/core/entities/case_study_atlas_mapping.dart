import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'case_study_atlas_mapping.freezed.dart';

/// Optional ATLAS mapping attached to a case study.
@freezed
abstract class CaseStudyAtlasMapping with _$CaseStudyAtlasMapping {
  /// Creates an ATLAS mapping.
  const factory CaseStudyAtlasMapping({
    required NonEmptyText summary,
    @Default(<NonEmptyText>[]) List<NonEmptyText> tacticsAndTechniques,
    @Default(<NonEmptyText>[]) List<NonEmptyText> procedureExamples,
  }) = _CaseStudyAtlasMapping;
  const CaseStudyAtlasMapping._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        summary.failureOrNull,
        ...tacticsAndTechniques.map((item) => item.failureOrNull),
        ...procedureExamples.map((item) => item.failureOrNull),
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
