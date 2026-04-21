/// Shared configuration used by the browser-only CodersRank section adapter.
final class CodersRankSupportingSectionConfig {
  const CodersRankSupportingSectionConfig._();

  /// Username used by the retained CodersRank summary widget.
  static const String username = 'charlie-shub';

  /// Custom-element tag registered by the CodersRank summary script.
  static const String summaryTagName = 'codersrank-summary';

  /// Third-party summary script URL for the retained supporting widget.
  static const String summaryScriptUrl =
      'https://unpkg.com/@codersrank/summary@0.9.13/codersrank-summary.min.js';

  /// Script element id used to avoid injecting the summary script twice.
  static const String summaryScriptId = 'codersrank-summary-script';

  /// Poll interval used while waiting for custom-element registration.
  static const Duration registrationPollInterval = Duration(milliseconds: 150);

  /// Timeout for custom-element registration.
  static const Duration registrationTimeout = Duration(seconds: 8);

  /// Timeout for the retained summary widget to render visible content.
  static const Duration renderTimeout = Duration(seconds: 8);
}
