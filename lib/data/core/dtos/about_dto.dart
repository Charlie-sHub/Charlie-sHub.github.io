// Freezed keeps JSON settings on factory constructors in this DTO file.
// ignore_for_file: invalid_annotation_target, public_member_api_docs
// ignore_for_file: sort_unnamed_constructors_first

import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'about_dto.freezed.dart';
part 'about_dto.g.dart';

/// DTO for the website's single about entry.
@freezed
abstract class AboutDto with _$AboutDto {
  const AboutDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
  )
  const factory AboutDto({
    required AboutMetaJson meta,
    required AboutContentJson content,
  }) = _AboutDto;

  /// Creates an about DTO from raw JSON.
  factory AboutDto.fromJson(Map<String, dynamic> json) =>
      _$AboutDtoFromJson(json);

  /// Maps this DTO into a domain about entry.
  About toDomain() => About(
    slug: Slug(meta.slug),
    sourcePath: SingleLineText(meta.sourcePath),
    title: Title(content.title),
    professionalSummaryShort: content.professionalSummaryShort == null
        ? null
        : NonEmptyText(content.professionalSummaryShort!),
    profileImagePath: content.profileImagePath == null
        ? null
        : AssetPath(content.profileImagePath!),
    whoIAmProfessionally: NonEmptyText(content.whoIAmProfessionally),
    currentPositioning: NonEmptyText(content.currentPositioning),
    developmentBackground: NonEmptyText(content.developmentBackground),
    securityDirection: NonEmptyText(content.securityDirection),
    strengthsAndWorkingStyle: content.strengthsAndWorkingStyle
        .map(NonEmptyText.new)
        .toList(growable: false),
    selectedSkillsAndTools: content.selectedSkillsAndTools
        .map((group) => group.toDomain())
        .toList(growable: false),
    howIBuildSoftware: NonEmptyText(content.howIBuildSoftware),
    howDevelopmentAndSecurityConnect: NonEmptyText(
      content.howDevelopmentAndSecurityConnect,
    ),
  );
}

/// Raw JSON wrapper for about entry metadata.
@freezed
abstract class AboutMetaJson with _$AboutMetaJson {
  const AboutMetaJson._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory AboutMetaJson({
    required String type,
    required String slug,
    required String sourcePath,
  }) = _AboutMetaJson;

  /// Creates about metadata from raw JSON.
  factory AboutMetaJson.fromJson(Map<String, dynamic> json) =>
      _$AboutMetaJsonFromJson(json);
}

/// Raw JSON wrapper for about entry content fields.
@freezed
abstract class AboutContentJson with _$AboutContentJson {
  const AboutContentJson._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory AboutContentJson({
    required String title,
    required String whoIAmProfessionally,
    required String currentPositioning,
    required String developmentBackground,
    required String securityDirection,
    required List<String> strengthsAndWorkingStyle,
    required List<AboutSkillGroupDto> selectedSkillsAndTools,
    required String howIBuildSoftware,
    required String howDevelopmentAndSecurityConnect,
    String? professionalSummaryShort,
    @JsonKey(name: 'profile_image_path') String? profileImagePath,
  }) = _AboutContentJson;

  /// Creates about content fields from raw JSON.
  factory AboutContentJson.fromJson(Map<String, dynamic> json) =>
      _$AboutContentJsonFromJson(json);
}

/// DTO for grouped about-section skills and tools.
@freezed
abstract class AboutSkillGroupDto with _$AboutSkillGroupDto {
  const AboutSkillGroupDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
  )
  const factory AboutSkillGroupDto({
    required String label,
    required List<String> items,
  }) = _AboutSkillGroupDto;

  /// Creates an about skill group DTO from raw JSON.
  factory AboutSkillGroupDto.fromJson(Map<String, dynamic> json) =>
      _$AboutSkillGroupDtoFromJson(json);

  /// Maps this DTO into a domain skill group.
  AboutSkillGroup toDomain() => AboutSkillGroup(
    label: SingleLineText(label),
    items: items.map(SingleLineText.new).toList(growable: false),
  );
}
