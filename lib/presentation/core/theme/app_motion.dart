// Shared token names are kept short and self-describing to avoid noisy
// boilerplate docs on every constant.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

/// Shared motion tokens and reduced-motion helpers for presentation widgets.
final class AppMotion {
  const AppMotion._();

  static const Duration durationFast = Duration(milliseconds: 180);
  static const Duration durationStandard = Duration(milliseconds: 220);
  static const Duration durationSlow = Duration(milliseconds: 320);

  static const Curve curveStandard = Curves.easeOutCubic;
  static const Curve curveSmooth = Curves.easeInOutCubic;

  static const double distanceSmall = 8;
  static const double distanceStandard = 16;
}

extension AppMotionContext on BuildContext {
  bool get prefersReducedMotion {
    final mediaQuery = MediaQuery.maybeOf(this);

    if (mediaQuery == null) {
      return false;
    } else {
      return mediaQuery.disableAnimations || mediaQuery.accessibleNavigation;
    }
  }

  Duration resolveMotionDuration(Duration duration) {
    if (prefersReducedMotion) {
      return Duration.zero;
    } else {
      return duration;
    }
  }

  Curve resolveMotionCurve(Curve curve) {
    if (prefersReducedMotion) {
      return Curves.linear;
    } else {
      return curve;
    }
  }

  double resolveMotionDistance(double distance) {
    if (prefersReducedMotion) {
      return 0;
    } else {
      return distance;
    }
  }

  Offset resolveMotionOffset(Offset offset) {
    if (prefersReducedMotion) {
      return Offset.zero;
    } else {
      return offset;
    }
  }
}
