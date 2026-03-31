import 'package:charlie_shub_portfolio/domain/core/entities/course_details.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'course.freezed.dart';

/// Course content validated for trusted app state.
@freezed
abstract class Course with _$Course {
  /// Creates a course entry.
  const factory Course({
    required Slug slug,
    required SingleLineText sourcePath,
    required Title title,
    required NonEmptyText summary,
    required CourseDetails courseDetails,
    required List<NonEmptyText> topicsCovered,
    required List<NonEmptyText> relevance,
    AssetPath? badgeImagePath,
    DocumentPath? certificatePdfPath,
    @Default(<NonEmptyText>[]) List<NonEmptyText> keyTakeaways,
    @Default(<LinkReference>[]) List<LinkReference> proof,
  }) = _Course;
  const Course._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        slug.failureOrNull,
        sourcePath.failureOrNull,
        title.failureOrNull,
        summary.failureOrNull,
        badgeImagePath?.failureOrNull,
        certificatePdfPath?.failureOrNull,
        courseDetails.failureOption.fold(() => null, id),
        collectionFailureOrNull(topicsCovered, minLength: 1),
        collectionFailureOrNull(relevance, minLength: 1),
        ...topicsCovered.map((item) => item.failureOrNull),
        ...relevance.map((item) => item.failureOrNull),
        ...keyTakeaways.map((item) => item.failureOrNull),
        ...proof.map((item) => item.failureOption.fold(() => null, id)),
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
