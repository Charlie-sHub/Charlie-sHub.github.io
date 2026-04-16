import 'package:charlie_shub_portfolio/domain/core/entities/about_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/content_entry_type.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'about.freezed.dart';

/// About content represented as a domain entity.
@freezed
abstract class About with _$About {
  /// Creates an about entry.
  const factory About({
    required Slug slug,
    required SingleLineText sourcePath,
    required Title title,
    required NonEmptyText whoIAmProfessionally,
    required NonEmptyText currentPositioning,
    required NonEmptyText developmentBackground,
    required NonEmptyText securityDirection,
    required List<NonEmptyText> strengthsAndWorkingStyle,
    required List<AboutSkillGroup> selectedSkillsAndTools,
    required NonEmptyText howIBuildSoftware,
    required NonEmptyText howDevelopmentAndSecurityConnect,
    NonEmptyText? professionalSummaryShort,
  }) = _About;
  const About._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        slug.failureOrNull,
        sourcePath.failureOrNull,
        title.failureOrNull,
        professionalSummaryShort?.failureOrNull,
        whoIAmProfessionally.failureOrNull,
        currentPositioning.failureOrNull,
        developmentBackground.failureOrNull,
        securityDirection.failureOrNull,
        collectionFailureOrNull(strengthsAndWorkingStyle, minLength: 1),
        collectionFailureOrNull(selectedSkillsAndTools, minLength: 1),
        howIBuildSoftware.failureOrNull,
        howDevelopmentAndSecurityConnect.failureOrNull,
        ...strengthsAndWorkingStyle.map((item) => item.failureOrNull),
        ...selectedSkillsAndTools.map(
          (group) => group.failureOption.fold(() => null, id),
        ),
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Closed content type for this top-level entry.
  ContentEntryType get contentEntryType => ContentEntryType.aboutMe;

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
