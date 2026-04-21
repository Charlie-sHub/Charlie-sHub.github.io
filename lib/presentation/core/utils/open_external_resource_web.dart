// This file is the intentionally web-only implementation used by a
// conditional import to open external resources in a new browser tab.
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'package:charlie_shub_portfolio/presentation/core/utils/open_external_resource_config.dart';

/// Opens the provided resource in a new browser tab on Flutter Web.
void openExternalResource(String url) {
  html.window.open(
    url,
    externalResourceWindowTarget,
    externalResourceWindowFeatures,
  );
}
