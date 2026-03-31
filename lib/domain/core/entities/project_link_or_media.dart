import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_link_or_media.freezed.dart';

/// Project-related external links or local media references.
@freezed
abstract class ProjectLinkOrMedia with _$ProjectLinkOrMedia {
  /// Creates an asset-backed project reference.
  const factory ProjectLinkOrMedia.asset({
    required SingleLineText label,
    required AssetPath assetPath,
  }) = _ProjectAssetLinkOrMedia;

  /// Creates an external project reference.
  const factory ProjectLinkOrMedia.external({
    required SingleLineText label,
    required UrlValue url,
  }) = _ProjectExternalLinkOrMedia;

  const ProjectLinkOrMedia._();

  /// First validation failure across the active variant, if any.
  Option<ValueFailure<dynamic>> get failureOption => map(
    asset: (value) => firstFailureOrNone(<ValueFailure<dynamic>?>[
      value.label.failureOrNull,
      value.assetPath.failureOrNull,
    ]),
    external: (value) => firstFailureOrNone(<ValueFailure<dynamic>?>[
      value.label.failureOrNull,
      value.url.failureOrNull,
    ]),
  );

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
