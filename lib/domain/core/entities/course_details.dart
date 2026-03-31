import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_details.freezed.dart';

/// Course metadata attached to a course entry.
@freezed
abstract class CourseDetails with _$CourseDetails {
  /// Creates course details.
  const factory CourseDetails({
    required SingleLineText provider,
    required SingleLineText platform,
    required SingleLineText format,
    required SingleLineText level,
    SingleLineText? programContext,
  }) = _CourseDetails;
  const CourseDetails._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        provider.failureOrNull,
        platform.failureOrNull,
        format.failureOrNull,
        level.failureOrNull,
        programContext?.failureOrNull,
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
