// This file is the intentionally web-only implementation used by a
// conditional import to open external resources in a new browser tab.

import 'dart:js_interop';

import 'package:charlie_shub_portfolio/presentation/core/utils/open_external_resource_config.dart';

/// Opens the provided resource in a new browser tab on Flutter Web.
void openExternalResource(String url) {
  _openBrowserWindow(
    url,
    externalResourceWindowTarget,
    externalResourceWindowFeatures,
  );
}

@JS('window.open')
external void _openBrowserWindow(
  String url,
  String target,
  String features,
);
