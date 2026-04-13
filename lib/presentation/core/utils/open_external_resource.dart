import 'package:charlie_shub_portfolio/presentation/core/utils/open_external_resource_stub.dart'
    if (dart.library.html) 'package:charlie_shub_portfolio/presentation/core/utils/open_external_resource_web.dart'
    as impl;
import 'package:flutter/foundation.dart';

/// Opens a URL or repository-bundled document in a new browser tab when the
/// current platform supports it.
void openExternalResource(String url) => impl.openExternalResource(url);

/// Resolves the shared tap handler for link- and document-like widgets.
VoidCallback resolveOpenExternalResource(
  String url, {
  VoidCallback? onTap,
}) => onTap ?? () => openExternalResource(url);
