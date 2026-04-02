// Freezed keeps JSON settings on factory constructors in this DTO file.
// ignore_for_file: invalid_annotation_target, public_member_api_docs
// ignore_for_file: sort_unnamed_constructors_first
// ignore_for_file: always_put_required_named_parameters_first

import 'package:charlie_shub_portfolio/data/core/dtos/link_reference_dto.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification_credential_details.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'certification_dto.freezed.dart';
part 'certification_dto.g.dart';

/// DTO for certification content entries.
@freezed
abstract class CertificationDto with _$CertificationDto {
  const CertificationDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
  )
  const factory CertificationDto({
    required CertificationMetaJson meta,
    required CertificationContentJson content,
  }) = _CertificationDto;

  /// Creates a certification DTO from raw JSON.
  factory CertificationDto.fromJson(Map<String, dynamic> json) =>
      _$CertificationDtoFromJson(json);

  /// Maps this DTO into a domain certification entry.
  Certification toDomain() => Certification(
    slug: Slug(meta.slug),
    sourcePath: SingleLineText(meta.sourcePath),
    earnedDate: YearMonth(meta.earnedDate),
    title: Title(content.title),
    summary: NonEmptyText(content.summary),
    badgeImagePath: content.badgeImagePath == null
        ? null
        : AssetPath(content.badgeImagePath!),
    certificatePdfPath: content.certificatePdfPath == null
        ? null
        : DocumentPath(content.certificatePdfPath!),
    credentialDetails: content.credentialDetails.toDomain(),
    knowledgeAreas: content.knowledgeAreas
        .map(NonEmptyText.new)
        .toList(growable: false),
    toolsAndFrameworks: (content.toolsAndFrameworks ?? const <String>[])
        .map(NonEmptyText.new)
        .toList(growable: false),
    learningOutcomes: content.learningOutcomes
        .map(NonEmptyText.new)
        .toList(growable: false),
    proof: (content.proof ?? const <LinkReferenceDto>[])
        .map((item) => item.toDomain())
        .toList(growable: false),
  );
}

/// Raw JSON wrapper for certification metadata.
@freezed
abstract class CertificationMetaJson with _$CertificationMetaJson {
  const CertificationMetaJson._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory CertificationMetaJson({
    required String type,
    required String slug,
    required String sourcePath,
    required String earnedDate,
  }) = _CertificationMetaJson;

  /// Creates certification metadata from raw JSON.
  factory CertificationMetaJson.fromJson(Map<String, dynamic> json) =>
      _$CertificationMetaJsonFromJson(json);
}

/// Raw JSON wrapper for certification content fields.
@freezed
abstract class CertificationContentJson with _$CertificationContentJson {
  const CertificationContentJson._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory CertificationContentJson({
    required String title,
    required String summary,
    @JsonKey(name: 'badgeImagePath') String? badgeImagePath,
    @JsonKey(name: 'certificatePdfPath') String? certificatePdfPath,
    required CertificationCredentialDetailsDto credentialDetails,
    required List<String> knowledgeAreas,
    List<String>? toolsAndFrameworks,
    required List<String> learningOutcomes,
    List<LinkReferenceDto>? proof,
  }) = _CertificationContentJson;

  /// Creates certification content fields from raw JSON.
  factory CertificationContentJson.fromJson(Map<String, dynamic> json) =>
      _$CertificationContentJsonFromJson(json);
}

/// DTO for certification credential metadata.
@freezed
abstract class CertificationCredentialDetailsDto
    with _$CertificationCredentialDetailsDto {
  const CertificationCredentialDetailsDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory CertificationCredentialDetailsDto({
    required String issuer,
    String? platform,
    required String credentialType,
    required String level,
    String? programSize,
    String? programScope,
    String? focus,
    String? version,
    String? intendedAudience,
    String? updateNote,
  }) = _CertificationCredentialDetailsDto;

  /// Creates credential details from raw JSON.
  factory CertificationCredentialDetailsDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CertificationCredentialDetailsDtoFromJson(json);

  /// Maps this DTO into domain credential metadata.
  CertificationCredentialDetails toDomain() => CertificationCredentialDetails(
    issuer: SingleLineText(issuer),
    platform: platform == null ? null : SingleLineText(platform!),
    credentialType: SingleLineText(credentialType),
    level: SingleLineText(level),
    programSize: programSize == null ? null : SingleLineText(programSize!),
    programScope: programScope == null ? null : SingleLineText(programScope!),
    focus: focus == null ? null : SingleLineText(focus!),
    version: version == null ? null : SingleLineText(version!),
    intendedAudience: intendedAudience == null
        ? null
        : SingleLineText(intendedAudience!),
    updateNote: updateNote == null ? null : SingleLineText(updateNote!),
  );
}
