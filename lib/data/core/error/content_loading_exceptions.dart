/// Signals that a requested asset path could not be found in the bundle.
final class AssetNotFoundException implements Exception {
  /// Creates a missing-asset exception for the given bundle path.
  const AssetNotFoundException({
    required this.path,
  });

  /// The asset path that could not be found.
  final String path;
}

/// Carries the asset path and error details for content-loading failures that
/// occur before the repository maps them into domain-facing failures.
final class ContentLoadException implements Exception {
  /// Creates a content-loading exception with the failing asset path and
  /// captured error details.
  const ContentLoadException({
    required this.path,
    required this.errorString,
  });

  /// The asset path that triggered the loading failure.
  final String path;

  /// The captured error details for the failed content operation.
  final String errorString;
}
