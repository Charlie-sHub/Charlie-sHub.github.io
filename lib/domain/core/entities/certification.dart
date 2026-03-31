import 'package:charlie_shub_portfolio/domain/core/entities/certification_credential_details.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'certification.freezed.dart';

/// Certification content validated for trusted app state.
@freezed
abstract class Certification with _$Certification {
  /// Creates a certification entry.
  const factory Certification({
    required Slug slug,
    required SingleLineText sourcePath,
    required YearMonth earnedDate,
    required Title title,
    required NonEmptyText summary,
    required CertificationCredentialDetails credentialDetails,
    required List<NonEmptyText> knowledgeAreas,
    required List<NonEmptyText> learningOutcomes,
    AssetPath? badgeImagePath,
    DocumentPath? certificatePdfPath,
    @Default(<NonEmptyText>[]) List<NonEmptyText> toolsAndFrameworks,
    @Default(<LinkReference>[]) List<LinkReference> proof,
  }) = _Certification;
  const Certification._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        slug.failureOrNull,
        sourcePath.failureOrNull,
        earnedDate.failureOrNull,
        title.failureOrNull,
        summary.failureOrNull,
        badgeImagePath?.failureOrNull,
        certificatePdfPath?.failureOrNull,
        credentialDetails.failureOption.fold(() => null, id),
        collectionFailureOrNull(knowledgeAreas, minLength: 1),
        collectionFailureOrNull(learningOutcomes, minLength: 1),
        ...knowledgeAreas.map((item) => item.failureOrNull),
        ...toolsAndFrameworks.map((item) => item.failureOrNull),
        ...learningOutcomes.map((item) => item.failureOrNull),
        ...proof.map((item) => item.failureOption.fold(() => null, id)),
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
