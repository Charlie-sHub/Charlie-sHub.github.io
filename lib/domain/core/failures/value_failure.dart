import 'package:charlie_shub_portfolio/domain/core/failures/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'value_failure.freezed.dart';

/// Validation failures for raw values entering the trusted domain layer.
@freezed
sealed class ValueFailure<T> extends Failure with _$ValueFailure<T> {
  const ValueFailure._();

  const factory ValueFailure.emptyString({
    required T failedValue,
  }) = EmptyString<T>;

  const factory ValueFailure.multilineString({
    required T failedValue,
  }) = MultilineString<T>;

  const factory ValueFailure.stringExceedsLength({
    required T failedValue,
    required int maxLength,
  }) = StringExceedsLength<T>;

  const factory ValueFailure.collectionTooShort({
    required T failedValue,
    required int minLength,
  }) = CollectionTooShort<T>;

  const factory ValueFailure.invalidSlug({
    required T failedValue,
  }) = InvalidSlug<T>;

  const factory ValueFailure.invalidUrl({
    required T failedValue,
  }) = InvalidUrl<T>;

  const factory ValueFailure.invalidAssetPath({
    required T failedValue,
  }) = InvalidAssetPath<T>;

  const factory ValueFailure.invalidDocumentPath({
    required T failedValue,
  }) = InvalidDocumentPath<T>;

  const factory ValueFailure.invalidYearMonth({
    required T failedValue,
  }) = InvalidYearMonth<T>;

  @override
  String get message => switch (this) {
    EmptyString() => 'String must not be empty.',
    MultilineString() => 'String must not contain line breaks.',
    StringExceedsLength(:final maxLength) =>
      'String must not exceed $maxLength characters.',
    CollectionTooShort(:final minLength) =>
      'Collection must contain at least $minLength '
          'item${minLength == 1 ? '' : 's'}.',
    InvalidSlug() =>
      'Slug must use snake_case with lowercase letters and numbers only.',
    InvalidUrl() => 'URL must be a valid absolute URL.',
    InvalidAssetPath() => 'Asset path must start with assets/media/.',
    InvalidDocumentPath() => 'Document path must start with assets/documents/.',
    InvalidYearMonth() => 'Date must use the YYYY-MM format.',
  };
}
