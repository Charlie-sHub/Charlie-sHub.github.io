// This file is the intentionally web-only implementation used by a
// conditional import to open external resources in a new browser tab.
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

/// Opens the provided resource in a new browser tab on Flutter Web.
void openExternalResource(String url) {
  html.window.open(url, '_blank', 'noopener,noreferrer');
}
