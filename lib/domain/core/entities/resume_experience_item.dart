import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_experience_item.freezed.dart';

/// Professional experience item attached to a resume entry.
@freezed
abstract class ResumeExperienceItem with _$ResumeExperienceItem {
  /// Creates a resume experience item.
  const factory ResumeExperienceItem({
    required Title title,
    required SingleLineText location,
    required YearMonth startDate,
    required bool isOngoing,
    required List<NonEmptyText> highlights,
    SingleLineText? organization,
    YearMonth? endDate,
  }) = _ResumeExperienceItem;
  const ResumeExperienceItem._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        title.failureOrNull,
        organization?.failureOrNull,
        location.failureOrNull,
        startDate.failureOrNull,
        endDate?.failureOrNull,
        ongoingTimelineFailureOrNull(
          startDate: startDate,
          endDate: endDate,
          isOngoing: isOngoing,
        ),
        collectionFailureOrNull(highlights, minLength: 1),
        ...highlights.map((item) => item.failureOrNull),
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
