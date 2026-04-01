import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project_link_or_media.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/content_entry_type.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';

/// Project content validated for trusted app state.
@freezed
abstract class Project with _$Project {
  /// Creates a project entry.
  const factory Project({
    required Slug slug,
    required SingleLineText sourcePath,
    required YearMonth startDate,
    required bool isOngoing,
    required Title title,
    required NonEmptyText summary,
    required NonEmptyText roleAndScope,
    required NonEmptyText productContext,
    required List<SingleLineText> stack,
    required NonEmptyText implementation,
    required List<NonEmptyText> outcomes,
    YearMonth? endDate,
    AssetPath? thumbnailPath,
    AssetPath? heroImagePath,
    @Default(<AssetPath>[]) List<AssetPath> galleryImagePaths,
    NonEmptyText? securityAndQuality,
    @Default(<NonEmptyText>[]) List<NonEmptyText> lessons,
    @Default(<ProjectLinkOrMedia>[]) List<ProjectLinkOrMedia> linksAndMedia,
  }) = _Project;
  const Project._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        slug.failureOrNull,
        sourcePath.failureOrNull,
        startDate.failureOrNull,
        endDate?.failureOrNull,
        title.failureOrNull,
        summary.failureOrNull,
        thumbnailPath?.failureOrNull,
        heroImagePath?.failureOrNull,
        roleAndScope.failureOrNull,
        productContext.failureOrNull,
        collectionFailureOrNull(stack, minLength: 1),
        implementation.failureOrNull,
        securityAndQuality?.failureOrNull,
        collectionFailureOrNull(outcomes, minLength: 1),
        ...galleryImagePaths.map((item) => item.failureOrNull),
        ...stack.map((item) => item.failureOrNull),
        ...outcomes.map((item) => item.failureOrNull),
        ...lessons.map((item) => item.failureOrNull),
        ...linksAndMedia.map((item) => item.failureOption.fold(() => null, id)),
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Closed content type for this top-level entry.
  ContentEntryType get contentEntryType => ContentEntryType.project;

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
