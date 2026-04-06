import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_education_item.freezed.dart';

/// Education item attached to a resume entry.
@freezed
abstract class ResumeEducationItem with _$ResumeEducationItem {
  /// Creates a resume education item.
  const factory ResumeEducationItem({
    required Title title,
    required SingleLineText institution,
    required SingleLineText location,
    required YearMonth startDate,
    required YearMonth endDate,
  }) = _ResumeEducationItem;
  const ResumeEducationItem._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        title.failureOrNull,
        institution.failureOrNull,
        location.failureOrNull,
        startDate.failureOrNull,
        endDate.failureOrNull,
        dateRangeFailureOrNull(
          startDate: startDate,
          endDate: endDate,
        ),
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
