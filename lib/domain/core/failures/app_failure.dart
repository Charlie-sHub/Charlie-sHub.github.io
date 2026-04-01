import 'package:charlie_shub_portfolio/domain/core/failures/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

/// Application and infrastructure failures outside the validation boundary.
@freezed
sealed class AppFailure extends Failure with _$AppFailure {
  const AppFailure._();

  const factory AppFailure.assetNotFound({
    required String path,
  }) = AssetNotFound;

  const factory AppFailure.contentLoadError({
    required String path,
    required String errorString,
  }) = ContentLoadError;

  const factory AppFailure.mediaLoadError({
    required String path,
    required String errorString,
  }) = MediaLoadError;

  const factory AppFailure.documentOpenError({
    required String path,
    required String errorString,
  }) = DocumentOpenError;

  const factory AppFailure.unexpectedError({
    required String errorString,
  }) = UnexpectedError;

  @override
  String get message => switch (this) {
    AssetNotFound(:final path) => 'Asset was not found at $path.',
    ContentLoadError(:final path, :final errorString) =>
      'Failed to load content from $path: $errorString',
    MediaLoadError(:final path, :final errorString) =>
      'Failed to load media from $path: $errorString',
    DocumentOpenError(:final path, :final errorString) =>
      'Failed to open document at $path: $errorString',
    UnexpectedError(:final errorString) =>
      'An unexpected error occurred: $errorString',
  };
}
