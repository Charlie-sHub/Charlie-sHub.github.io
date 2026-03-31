import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'case_study_indicators.freezed.dart';

/// Indicators and related notes attached to a case study.
@freezed
abstract class CaseStudyIndicators with _$CaseStudyIndicators {
  /// Creates a case study indicators group.
  const factory CaseStudyIndicators({
    required List<NonEmptyText> items,
    NonEmptyText? summary,
  }) = _CaseStudyIndicators;
  const CaseStudyIndicators._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        summary?.failureOrNull,
        collectionFailureOrNull(items, minLength: 1),
        ...items.map((item) => item.failureOrNull),
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
