import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'certification_credential_details.freezed.dart';

/// Credential metadata attached to a certification entry.
@freezed
abstract class CertificationCredentialDetails
    with _$CertificationCredentialDetails {
  /// Creates credential details.
  const factory CertificationCredentialDetails({
    required SingleLineText issuer,
    required SingleLineText credentialType,
    required SingleLineText level,
    SingleLineText? platform,
    SingleLineText? programSize,
    SingleLineText? programScope,
    SingleLineText? focus,
    SingleLineText? version,
    SingleLineText? intendedAudience,
    SingleLineText? updateNote,
  }) = _CertificationCredentialDetails;
  const CertificationCredentialDetails._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        issuer.failureOrNull,
        platform?.failureOrNull,
        credentialType.failureOrNull,
        level.failureOrNull,
        programSize?.failureOrNull,
        programScope?.failureOrNull,
        focus?.failureOrNull,
        version?.failureOrNull,
        intendedAudience?.failureOrNull,
        updateNote?.failureOrNull,
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
