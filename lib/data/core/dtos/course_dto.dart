// Freezed keeps JSON settings on factory constructors in this DTO file.
// ignore_for_file: invalid_annotation_target, public_member_api_docs
// ignore_for_file: sort_unnamed_constructors_first
// ignore_for_file: always_put_required_named_parameters_first

import 'package:charlie_shub_portfolio/data/core/dtos/link_reference_dto.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course_details.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_dto.freezed.dart';
part 'course_dto.g.dart';

/// DTO for structured course content.
@freezed
abstract class CourseDto with _$CourseDto {
  const CourseDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
  )
  const factory CourseDto({
    required CourseMetaJson meta,
    required CourseContentJson content,
  }) = _CourseDto;

  /// Creates a course DTO from raw JSON.
  factory CourseDto.fromJson(Map<String, dynamic> json) =>
      _$CourseDtoFromJson(json);

  /// Maps this DTO into a domain course entry.
  Course toDomain() => Course(
    slug: Slug(meta.slug),
    sourcePath: SingleLineText(meta.sourcePath),
    title: Title(content.title),
    summary: NonEmptyText(content.summary),
    badgeImagePath: content.badgeImagePath == null
        ? null
        : AssetPath(content.badgeImagePath!),
    certificatePdfPath: content.certificatePdfPath == null
        ? null
        : DocumentPath(content.certificatePdfPath!),
    courseDetails: content.courseDetails.toDomain(),
    topicsCovered: content.topicsCovered
        .map(NonEmptyText.new)
        .toList(growable: false),
    relevance: content.relevance.map(NonEmptyText.new).toList(growable: false),
    keyTakeaways: (content.keyTakeaways ?? const <String>[])
        .map(NonEmptyText.new)
        .toList(growable: false),
    proof: (content.proof ?? const <LinkReferenceDto>[])
        .map((item) => item.toDomain())
        .toList(growable: false),
  );
}

/// Raw JSON wrapper for course metadata.
@freezed
abstract class CourseMetaJson with _$CourseMetaJson {
  const CourseMetaJson._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory CourseMetaJson({
    required String type,
    required String slug,
    required String sourcePath,
  }) = _CourseMetaJson;

  /// Creates course metadata from raw JSON.
  factory CourseMetaJson.fromJson(Map<String, dynamic> json) =>
      _$CourseMetaJsonFromJson(json);
}

/// Raw JSON wrapper for course content fields.
@freezed
abstract class CourseContentJson with _$CourseContentJson {
  const CourseContentJson._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
    fieldRename: FieldRename.snake,
  )
  const factory CourseContentJson({
    required String title,
    required String summary,
    @JsonKey(name: 'badgeImagePath') String? badgeImagePath,
    @JsonKey(name: 'certificatePdfPath') String? certificatePdfPath,
    required CourseDetailsDto courseDetails,
    required List<String> topicsCovered,
    required List<String> relevance,
    List<String>? keyTakeaways,
    List<LinkReferenceDto>? proof,
  }) = _CourseContentJson;

  /// Creates course content fields from raw JSON.
  factory CourseContentJson.fromJson(Map<String, dynamic> json) =>
      _$CourseContentJsonFromJson(json);
}

/// DTO for course metadata details.
@freezed
abstract class CourseDetailsDto with _$CourseDetailsDto {
  const CourseDetailsDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory CourseDetailsDto({
    required String provider,
    required String platform,
    required String format,
    required String level,
    String? programContext,
  }) = _CourseDetailsDto;

  /// Creates course details from raw JSON.
  factory CourseDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$CourseDetailsDtoFromJson(json);

  /// Maps this DTO into domain course details.
  CourseDetails toDomain() => CourseDetails(
    provider: SingleLineText(provider),
    platform: SingleLineText(platform),
    format: SingleLineText(format),
    level: SingleLineText(level),
    programContext: programContext == null
        ? null
        : SingleLineText(programContext!),
  );
}
