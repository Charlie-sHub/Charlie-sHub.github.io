// Freezed keeps JSON settings on factory constructors in this DTO file.
// ignore_for_file: invalid_annotation_target, public_member_api_docs
// ignore_for_file: sort_unnamed_constructors_first

import 'package:freezed_annotation/freezed_annotation.dart';

part 'section_manifest_dto.freezed.dart';
part 'section_manifest_dto.g.dart';

/// DTO for a lightweight section manifest stored at `assets/content/*/index.json`.
@freezed
abstract class SectionManifestDto with _$SectionManifestDto {
  const SectionManifestDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    explicitToJson: true,
  )
  const factory SectionManifestDto({
    required List<SectionManifestItemDto> items,
  }) = _SectionManifestDto;

  /// Creates a section manifest DTO from raw JSON.
  factory SectionManifestDto.fromJson(Map<String, dynamic> json) =>
      _$SectionManifestDtoFromJson(json);
}

/// Lightweight manifest item used for section discovery and ordering.
@freezed
abstract class SectionManifestItemDto with _$SectionManifestItemDto {
  const SectionManifestItemDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
    fieldRename: FieldRename.snake,
  )
  const factory SectionManifestItemDto({
    required String file,
    int? order,
  }) = _SectionManifestItemDto;

  /// Creates a section manifest item DTO from raw JSON.
  factory SectionManifestItemDto.fromJson(Map<String, dynamic> json) =>
      _$SectionManifestItemDtoFromJson(json);
}
