// Freezed keeps JSON settings on factory constructors in this DTO file.
// ignore_for_file: invalid_annotation_target, public_member_api_docs
// ignore_for_file: sort_unnamed_constructors_first
// ignore_for_file: always_put_required_named_parameters_first

import 'package:charlie_shub_portfolio/data/core/dtos/link_reference_dto.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_education_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_experience_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/language_proficiency.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/email_address.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_dto.freezed.dart';
part 'resume_dto.g.dart';

/// DTO for the website's resume entry.
@freezed
abstract class ResumeDto with _$ResumeDto {
  const ResumeDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
  )
  const factory ResumeDto({
    required ResumeMetaJson meta,
    required ResumeContentJson content,
  }) = _ResumeDto;

  /// Creates a resume DTO from raw JSON.
  factory ResumeDto.fromJson(Map<String, dynamic> json) =>
      _$ResumeDtoFromJson(json);

  /// Maps this DTO into a domain resume entry.
  Resume toDomain() => Resume(
    slug: Slug(meta.slug),
    sourcePath: SingleLineText(meta.sourcePath),
    name: SingleLineText(content.name),
    location: SingleLineText(content.location),
    summary: NonEmptyText(content.summary),
    directEmailAddress: content.directEmailAddress == null
        ? null
        : EmailAddress(content.directEmailAddress!),
    resumePdfPath: content.resumePdfPath == null
        ? null
        : DocumentPath(content.resumePdfPath!),
    contactLinks: content.contactLinks
        .map((item) => item.toDomain())
        .toList(growable: false),
    coreSkills: content.coreSkills
        .map((item) => item.toDomain())
        .toList(growable: false),
    professionalExperience: content.professionalExperience
        .map((item) => item.toDomain())
        .toList(growable: false),
    education: content.education
        .map((item) => item.toDomain())
        .toList(growable: false),
    languages: content.languages
        .map((item) => item.toDomain())
        .toList(growable: false),
  );
}

/// Raw JSON wrapper for resume metadata.
@freezed
abstract class ResumeMetaJson with _$ResumeMetaJson {
  const ResumeMetaJson._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory ResumeMetaJson({
    required String type,
    required String slug,
    required String sourcePath,
  }) = _ResumeMetaJson;

  /// Creates resume metadata from raw JSON.
  factory ResumeMetaJson.fromJson(Map<String, dynamic> json) =>
      _$ResumeMetaJsonFromJson(json);
}

/// Raw JSON wrapper for resume content fields.
@freezed
abstract class ResumeContentJson with _$ResumeContentJson {
  const ResumeContentJson._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory ResumeContentJson({
    required String name,
    required String location,
    required String summary,
    @JsonKey(name: 'resumePdfPath') String? resumePdfPath,
    String? directEmailAddress,
    required List<LinkReferenceDto> contactLinks,
    required List<ResumeSkillGroupDto> coreSkills,
    required List<ResumeExperienceItemDto> professionalExperience,
    required List<ResumeEducationItemDto> education,
    required List<ResumeLanguageItemDto> languages,
  }) = _ResumeContentJson;

  /// Creates resume content fields from raw JSON.
  factory ResumeContentJson.fromJson(Map<String, dynamic> json) =>
      _$ResumeContentJsonFromJson(json);
}

/// DTO for grouped resume skills.
@freezed
abstract class ResumeSkillGroupDto with _$ResumeSkillGroupDto {
  const ResumeSkillGroupDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
  )
  const factory ResumeSkillGroupDto({
    required String label,
    required List<String> items,
  }) = _ResumeSkillGroupDto;

  /// Creates a resume skill-group DTO from raw JSON.
  factory ResumeSkillGroupDto.fromJson(Map<String, dynamic> json) =>
      _$ResumeSkillGroupDtoFromJson(json);

  /// Maps this DTO into a domain skill group.
  ResumeSkillGroup toDomain() => ResumeSkillGroup(
    label: SingleLineText(label),
    items: items.map(SingleLineText.new).toList(growable: false),
  );
}

/// DTO for resume professional-experience entries.
@freezed
abstract class ResumeExperienceItemDto with _$ResumeExperienceItemDto {
  const ResumeExperienceItemDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory ResumeExperienceItemDto({
    required String title,
    String? organization,
    required String location,
    required String startDate,
    @JsonKey(required: true) String? endDate,
    required bool isOngoing,
    required List<String> highlights,
  }) = _ResumeExperienceItemDto;

  /// Creates a resume experience-item DTO from raw JSON.
  factory ResumeExperienceItemDto.fromJson(Map<String, dynamic> json) =>
      _$ResumeExperienceItemDtoFromJson(json);

  /// Maps this DTO into a domain experience item.
  ResumeExperienceItem toDomain() => ResumeExperienceItem(
    title: Title(title),
    organization: organization == null ? null : SingleLineText(organization!),
    location: SingleLineText(location),
    startDate: YearMonth(startDate),
    endDate: endDate == null ? null : YearMonth(endDate!),
    isOngoing: isOngoing,
    highlights: highlights.map(NonEmptyText.new).toList(growable: false),
  );
}

/// DTO for resume education entries.
@freezed
abstract class ResumeEducationItemDto with _$ResumeEducationItemDto {
  const ResumeEducationItemDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory ResumeEducationItemDto({
    required String title,
    required String institution,
    required String location,
    required String startDate,
    required String endDate,
  }) = _ResumeEducationItemDto;

  /// Creates a resume education-item DTO from raw JSON.
  factory ResumeEducationItemDto.fromJson(Map<String, dynamic> json) =>
      _$ResumeEducationItemDtoFromJson(json);

  /// Maps this DTO into a domain education item.
  ResumeEducationItem toDomain() => ResumeEducationItem(
    title: Title(title),
    institution: SingleLineText(institution),
    location: SingleLineText(location),
    startDate: YearMonth(startDate),
    endDate: YearMonth(endDate),
  );
}

/// DTO for resume language proficiency entries.
@freezed
abstract class ResumeLanguageItemDto with _$ResumeLanguageItemDto {
  const ResumeLanguageItemDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
  )
  const factory ResumeLanguageItemDto({
    required String language,
    required String proficiency,
  }) = _ResumeLanguageItemDto;

  /// Creates a resume language-item DTO from raw JSON.
  factory ResumeLanguageItemDto.fromJson(Map<String, dynamic> json) =>
      _$ResumeLanguageItemDtoFromJson(json);

  /// Maps this DTO into a domain language item.
  ResumeLanguageItem toDomain() => ResumeLanguageItem(
    language: SingleLineText(language),
    proficiency: LanguageProficiency.fromString(proficiency),
  );
}
