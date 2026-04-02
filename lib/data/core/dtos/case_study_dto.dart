// Freezed keeps JSON settings on factory constructors in this DTO file.
// ignore_for_file: invalid_annotation_target, public_member_api_docs
// ignore_for_file: sort_unnamed_constructors_first
// ignore_for_file: always_put_required_named_parameters_first

import 'package:charlie_shub_portfolio/data/core/dtos/link_reference_dto.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study_atlas_mapping.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study_attack_mapping.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study_indicators.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'case_study_dto.freezed.dart';
part 'case_study_dto.g.dart';

/// DTO for structured case study content.
@freezed
abstract class CaseStudyDto with _$CaseStudyDto {
  const CaseStudyDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
  )
  const factory CaseStudyDto({
    required CaseStudyMetaJson meta,
    required CaseStudyContentJson content,
  }) = _CaseStudyDto;

  /// Creates a case study DTO from raw JSON.
  factory CaseStudyDto.fromJson(Map<String, dynamic> json) =>
      _$CaseStudyDtoFromJson(json);

  /// Maps this DTO into a domain case study.
  CaseStudy toDomain() => CaseStudy(
    slug: Slug(meta.slug),
    sourcePath: SingleLineText(meta.sourcePath),
    incidentCode: meta.incidentCode == null
        ? null
        : SingleLineText(meta.incidentCode!),
    title: Title(content.title),
    summary: NonEmptyText(content.summary),
    incidentOverview: NonEmptyText(content.incidentOverview),
    adversaryObjectives: NonEmptyText(content.adversaryObjectives),
    attackMapping: content.attackMapping.toDomain(),
    defensiveMapping: content.defensiveMapping == null
        ? null
        : NonEmptyText(content.defensiveMapping!),
    atlasMapping: content.atlasMapping?.toDomain(),
    indicators: content.indicators?.toDomain(),
    defensiveAnalysis: NonEmptyText(content.defensiveAnalysis),
    lessonsLearned: content.lessonsLearned
        .map(NonEmptyText.new)
        .toList(growable: false),
    reflection: NonEmptyText(content.reflection),
    references: content.references
        .map((reference) => reference.toDomain())
        .toList(growable: false),
  );
}

/// Raw JSON wrapper for case study metadata.
@freezed
abstract class CaseStudyMetaJson with _$CaseStudyMetaJson {
  const CaseStudyMetaJson._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory CaseStudyMetaJson({
    required String type,
    required String slug,
    required String sourcePath,
    String? incidentCode,
  }) = _CaseStudyMetaJson;

  /// Creates case study metadata from raw JSON.
  factory CaseStudyMetaJson.fromJson(Map<String, dynamic> json) =>
      _$CaseStudyMetaJsonFromJson(json);
}

/// Raw JSON wrapper for case study content fields.
@freezed
abstract class CaseStudyContentJson with _$CaseStudyContentJson {
  const CaseStudyContentJson._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory CaseStudyContentJson({
    required String title,
    required String summary,
    required String incidentOverview,
    required String adversaryObjectives,
    required CaseStudyAttackMappingDto attackMapping,
    String? defensiveMapping,
    CaseStudyAtlasMappingDto? atlasMapping,
    CaseStudyIndicatorsDto? indicators,
    required String defensiveAnalysis,
    required List<String> lessonsLearned,
    required String reflection,
    required List<LinkReferenceDto> references,
  }) = _CaseStudyContentJson;

  /// Creates case study content fields from raw JSON.
  factory CaseStudyContentJson.fromJson(Map<String, dynamic> json) =>
      _$CaseStudyContentJsonFromJson(json);
}

/// DTO for ATT&CK mappings attached to a case study.
@freezed
abstract class CaseStudyAttackMappingDto with _$CaseStudyAttackMappingDto {
  const CaseStudyAttackMappingDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory CaseStudyAttackMappingDto({
    required List<String> tactics,
    required List<String> techniques,
    required List<String> procedureExamples,
  }) = _CaseStudyAttackMappingDto;

  /// Creates an attack-mapping DTO from raw JSON.
  factory CaseStudyAttackMappingDto.fromJson(Map<String, dynamic> json) =>
      _$CaseStudyAttackMappingDtoFromJson(json);

  /// Maps this DTO into a domain ATT&CK mapping.
  CaseStudyAttackMapping toDomain() => CaseStudyAttackMapping(
    tactics: tactics.map(NonEmptyText.new).toList(growable: false),
    techniques: techniques.map(NonEmptyText.new).toList(growable: false),
    procedureExamples: procedureExamples
        .map(NonEmptyText.new)
        .toList(growable: false),
  );
}

/// DTO for optional ATLAS mappings attached to a case study.
@freezed
abstract class CaseStudyAtlasMappingDto with _$CaseStudyAtlasMappingDto {
  const CaseStudyAtlasMappingDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory CaseStudyAtlasMappingDto({
    required String summary,
    List<String>? tacticsAndTechniques,
    List<String>? procedureExamples,
  }) = _CaseStudyAtlasMappingDto;

  /// Creates an ATLAS-mapping DTO from raw JSON.
  factory CaseStudyAtlasMappingDto.fromJson(Map<String, dynamic> json) =>
      _$CaseStudyAtlasMappingDtoFromJson(json);

  /// Maps this DTO into a domain ATLAS mapping.
  CaseStudyAtlasMapping toDomain() => CaseStudyAtlasMapping(
    summary: NonEmptyText(summary),
    tacticsAndTechniques: (tacticsAndTechniques ?? const <String>[])
        .map(NonEmptyText.new)
        .toList(growable: false),
    procedureExamples: (procedureExamples ?? const <String>[])
        .map(NonEmptyText.new)
        .toList(growable: false),
  );
}

/// DTO for case-study indicators and related notes.
@freezed
abstract class CaseStudyIndicatorsDto with _$CaseStudyIndicatorsDto {
  const CaseStudyIndicatorsDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
  )
  const factory CaseStudyIndicatorsDto({
    required List<String> items,
    String? summary,
  }) = _CaseStudyIndicatorsDto;

  /// Creates a case-study indicators DTO from raw JSON.
  factory CaseStudyIndicatorsDto.fromJson(Map<String, dynamic> json) =>
      _$CaseStudyIndicatorsDtoFromJson(json);

  /// Maps this DTO into a domain indicators block.
  CaseStudyIndicators toDomain() => CaseStudyIndicators(
    items: items.map(NonEmptyText.new).toList(growable: false),
    summary: summary == null ? null : NonEmptyText(summary!),
  );
}
