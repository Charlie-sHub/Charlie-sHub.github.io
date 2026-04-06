// Freezed keeps JSON settings on factory constructors in this DTO file.
// ignore_for_file: invalid_annotation_target, public_member_api_docs
// ignore_for_file: sort_unnamed_constructors_first
// ignore_for_file: always_put_required_named_parameters_first

import 'package:charlie_shub_portfolio/data/core/dtos/link_reference_dto.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_dto.freezed.dart';
part 'project_dto.g.dart';

/// DTO for structured project content.
@freezed
abstract class ProjectDto with _$ProjectDto {
  const ProjectDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
  )
  const factory ProjectDto({
    required ProjectMetaJson meta,
    required ProjectContentJson content,
  }) = _ProjectDto;

  /// Creates a project DTO from raw JSON.
  factory ProjectDto.fromJson(Map<String, dynamic> json) =>
      _$ProjectDtoFromJson(json);

  /// Maps this DTO into a domain project entry.
  Project toDomain() => Project(
    slug: Slug(meta.slug),
    sourcePath: SingleLineText(meta.sourcePath),
    startDate: YearMonth(meta.startDate),
    endDate: meta.endDate == null ? null : YearMonth(meta.endDate!),
    isOngoing: meta.isOngoing,
    title: Title(content.title),
    summary: NonEmptyText(content.summary),
    thumbnailPath: content.thumbnailPath == null
        ? null
        : AssetPath(content.thumbnailPath!),
    heroImagePath: content.heroImagePath == null
        ? null
        : AssetPath(content.heroImagePath!),
    galleryImagePaths: (content.galleryImagePaths ?? const <String>[])
        .map(AssetPath.new)
        .toList(growable: false),
    roleAndScope: NonEmptyText(content.roleAndScope),
    productContext: NonEmptyText(content.productContext),
    stack: content.stack.map(SingleLineText.new).toList(growable: false),
    implementation: NonEmptyText(content.implementation),
    securityAndQuality: content.securityAndQuality == null
        ? null
        : NonEmptyText(content.securityAndQuality!),
    outcomes: content.outcomes.map(NonEmptyText.new).toList(growable: false),
    lessons: (content.lessons ?? const <String>[])
        .map(NonEmptyText.new)
        .toList(growable: false),
    links: (content.links ?? const <LinkReferenceDto>[])
        .map((item) => item.toDomain())
        .toList(growable: false),
  );
}

/// Raw JSON wrapper for project metadata.
@freezed
abstract class ProjectMetaJson with _$ProjectMetaJson {
  const ProjectMetaJson._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory ProjectMetaJson({
    required String type,
    required String slug,
    required String sourcePath,
    required String startDate,
    @JsonKey(required: true) String? endDate,
    required bool isOngoing,
  }) = _ProjectMetaJson;

  /// Creates project metadata from raw JSON.
  factory ProjectMetaJson.fromJson(Map<String, dynamic> json) =>
      _$ProjectMetaJsonFromJson(json);
}

/// Raw JSON wrapper for project content fields.
@freezed
abstract class ProjectContentJson with _$ProjectContentJson {
  const ProjectContentJson._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory ProjectContentJson({
    required String title,
    required String summary,
    @JsonKey(name: 'thumbnailPath') String? thumbnailPath,
    @JsonKey(name: 'heroImagePath') String? heroImagePath,
    @JsonKey(name: 'galleryImagePaths') List<String>? galleryImagePaths,
    required String roleAndScope,
    required String productContext,
    required List<String> stack,
    required String implementation,
    String? securityAndQuality,
    required List<String> outcomes,
    List<String>? lessons,
    List<LinkReferenceDto>? links,
  }) = _ProjectContentJson;

  /// Creates project content fields from raw JSON.
  factory ProjectContentJson.fromJson(Map<String, dynamic> json) =>
      _$ProjectContentJsonFromJson(json);
}
