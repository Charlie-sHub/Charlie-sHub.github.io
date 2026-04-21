import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/link_reference_kind.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_reference.freezed.dart';

/// External link reference used by content entities.
@freezed
abstract class LinkReference with _$LinkReference {
  /// Creates a link reference.
  const factory LinkReference({
    required SingleLineText label,
    required UrlValue url,
    @Default(LinkReferenceKind.external) LinkReferenceKind kind,
  }) = _LinkReference;
  const LinkReference._();

  /// First validation failure across the entity and nested values, if any.
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
