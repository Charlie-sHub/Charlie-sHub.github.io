/// Overall lifecycle for loading the portfolio's public content.
enum ContentStatus {
  /// Content has not been requested yet.
  initial,

  /// Content loading orchestration is currently running.
  loading,

  /// The orchestration completed, even if some sections contain local failures.
  loaded,

  /// An unexpected error prevented the orchestration from finishing.
  failure,
}
