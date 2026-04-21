import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_education_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_experience_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/content_entry_type.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/email_address.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume.freezed.dart';

/// Resume content represented as a domain entity.
@freezed
abstract class Resume with _$Resume {
  /// Creates a resume entry.
  const factory Resume({
    required Slug slug,
    required SingleLineText sourcePath,
    required SingleLineText name,
    required SingleLineText location,
    required NonEmptyText summary,
    required List<LinkReference> contactLinks,
    required List<ResumeSkillGroup> coreSkills,
    required List<ResumeExperienceItem> professionalExperience,
    required List<ResumeEducationItem> education,
    required List<ResumeLanguageItem> languages,
    EmailAddress? directEmailAddress,
    DocumentPath? resumePdfPath,
  }) = _Resume;
  const Resume._();

  /// First validation failure across the entity and nested values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        slug.failureOrNull,
        sourcePath.failureOrNull,
        name.failureOrNull,
        location.failureOrNull,
        summary.failureOrNull,
        resumePdfPath?.failureOrNull,
        directEmailAddress?.failureOrNull,
        collectionFailureOrNull(contactLinks, minLength: 1),
        collectionFailureOrNull(coreSkills, minLength: 1),
        collectionFailureOrNull(professionalExperience, minLength: 1),
        collectionFailureOrNull(education, minLength: 1),
        collectionFailureOrNull(languages, minLength: 1),
        ...contactLinks.map((item) => item.failureOption.fold(() => null, id)),
        ...coreSkills.map((item) => item.failureOption.fold(() => null, id)),
        ...professionalExperience.map(
          (item) => item.failureOption.fold(() => null, id),
        ),
        ...education.map((item) => item.failureOption.fold(() => null, id)),
        ...languages.map((item) => item.failureOption.fold(() => null, id)),
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Closed content type for this top-level entry.
  ContentEntryType get contentEntryType => ContentEntryType.resume;

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
