// Freezed keeps JSON settings on factory constructors in this DTO file.
// ignore_for_file: invalid_annotation_target, public_member_api_docs
// ignore_for_file: sort_unnamed_constructors_first

import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/link_reference_kind.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_reference_dto.freezed.dart';
part 'link_reference_dto.g.dart';

/// DTO for external link references stored in JSON content.
@freezed
abstract class LinkReferenceDto with _$LinkReferenceDto {
  const LinkReferenceDto._();

  @JsonSerializable(
    checked: true,
    disallowUnrecognizedKeys: true,
  )
  const factory LinkReferenceDto({
    required String label,
    required String url,
    String? kind,
  }) = _LinkReferenceDto;

  /// Creates a link reference DTO from raw JSON.
  factory LinkReferenceDto.fromJson(Map<String, dynamic> json) =>
      _$LinkReferenceDtoFromJson(json);

  /// Maps this DTO into a domain link reference.
  LinkReference toDomain() => LinkReference(
    label: SingleLineText(label),
    url: UrlValue(url),
    kind: LinkReferenceKind.fromString(kind),
  );
}
