import 'package:flutter/foundation.dart';

const _canonicalAssetPrefix = 'assets/';
const _webAssetPrefix = 'assets/assets/';

/// Resolves raw browser URLs for same-origin Flutter Web asset paths.
///
/// Repository and content sources keep canonical `assets/...` keys, while the
/// emitted web output serves those files from `assets/assets/...`.
String resolveBrowserFacingAssetUrl(
  String url, {
  bool isWeb = kIsWeb,
  Uri? baseUri,
}) {
  if (!isWeb) {
    return url;
  }

  final browserRelativeUrl = _resolveBrowserRelativeAssetUrl(url);
  if (browserRelativeUrl == null) {
    return url;
  }

  final effectiveBaseUri = baseUri ?? Uri.base;

  return effectiveBaseUri.resolve(browserRelativeUrl).toString();
}

String? _resolveBrowserRelativeAssetUrl(String url) {
  if (url.startsWith(_webAssetPrefix)) {
    return url;
  } else if (url.startsWith(_canonicalAssetPrefix)) {
    return 'assets/$url';
  } else {
    return null;
  }
}
