import 'package:charlie_shub_portfolio/domain/core/entities/case_study_atlas_mapping.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study_attack_mapping.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study_indicators.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'case_study.freezed.dart';

/// Security case study content validated for trusted app state.
@freezed
abstract class CaseStudy with _$CaseStudy {
  /// Creates a case study entry.
  const factory CaseStudy({
    required Slug slug,
    required SingleLineText sourcePath,
    required Title title,
    required NonEmptyText summary,
    required NonEmptyText incidentOverview,
    required NonEmptyText adversaryObjectives,
    required CaseStudyAttackMapping attackMapping,
    required NonEmptyText defensiveAnalysis,
    required List<NonEmptyText> lessonsLearned,
    required NonEmptyText reflection,
    required List<LinkReference> references,
    SingleLineText? incidentCode,
    NonEmptyText? defensiveMapping,
    CaseStudyAtlasMapping? atlasMapping,
    CaseStudyIndicators? indicators,
  }) = _CaseStudy;
  const CaseStudy._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        slug.failureOrNull,
        sourcePath.failureOrNull,
        incidentCode?.failureOrNull,
        title.failureOrNull,
        summary.failureOrNull,
        incidentOverview.failureOrNull,
        adversaryObjectives.failureOrNull,
        attackMapping.failureOption.fold(() => null, id),
        defensiveMapping?.failureOrNull,
        atlasMapping?.failureOption.fold(() => null, id),
        indicators?.failureOption.fold(() => null, id),
        defensiveAnalysis.failureOrNull,
        collectionFailureOrNull(lessonsLearned, minLength: 1),
        reflection.failureOrNull,
        collectionFailureOrNull(references, minLength: 1),
        ...lessonsLearned.map((item) => item.failureOrNull),
        ...references.map((item) => item.failureOption.fold(() => null, id)),
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
