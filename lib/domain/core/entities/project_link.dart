import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_link.freezed.dart';

/// Project-related external link metadata.
@freezed
abstract class ProjectLink with _$ProjectLink {
  /// Creates a project link.
  const factory ProjectLink({
    required SingleLineText label,
    required UrlValue url,
  }) = _ProjectLink;

  const ProjectLink._();

  /// First validation failure across the link values, if any.
  Option<ValueFailure<dynamic>> get failureOption =>
      firstFailureOrNone(<ValueFailure<dynamic>?>[
        label.failureOrNull,
        url.failureOrNull,
      ]);

  /// Success when the entity is fully valid, otherwise the first failure.
  Either<ValueFailure<dynamic>, Unit> get failureOrUnit =>
      failureOption.fold(() => right(unit), left);

  /// Whether the entity is valid.
  bool get isValid => failureOption.isNone();
}
