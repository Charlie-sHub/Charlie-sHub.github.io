// Shared token names are kept short and self-describing to avoid noisy
// boilerplate docs on every constant.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

/// Shared spacing scale and insets for reusable presentation widgets.
final class AppSpacing {
  const AppSpacing._();

  static const double size4 = 4;
  static const double size6 = 6;
  static const double size8 = 8;
  static const double size10 = 10;
  static const double size12 = 12;
  static const double size14 = 14;
  static const double size16 = 16;
  static const double size18 = 18;
  static const double size20 = 20;
  static const double size24 = 24;

  static const EdgeInsets zero = EdgeInsets.zero;
  static const EdgeInsets pagePadding = EdgeInsets.all(size24);
  static const EdgeInsets sectionPadding = EdgeInsets.all(size24);
  static const EdgeInsets contentCardPadding = EdgeInsets.all(size20);
  static const EdgeInsets selectorPanelPadding = EdgeInsets.all(size12);
  static const EdgeInsets selectorButtonPadding = EdgeInsets.all(size12);
  static const EdgeInsets externalLinkTilePadding = EdgeInsets.symmetric(
    horizontal: size16,
    vertical: size14,
  );
  static const EdgeInsets fieldFailurePadding = EdgeInsets.symmetric(
    horizontal: size12,
    vertical: size8,
  );
  static const EdgeInsets tagChipPadding = EdgeInsets.symmetric(
    horizontal: size12,
    vertical: size8,
  );
  static const EdgeInsets bulletMarkerPadding = EdgeInsets.only(
    top: size6,
    right: size8,
  );
}
