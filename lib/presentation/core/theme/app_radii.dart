// Shared token names are kept short and self-describing to avoid noisy
// boilerplate docs on every constant.
// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

/// Shared corner treatments for reusable presentation widgets.
final class AppRadii {
  const AppRadii._();

  static const BorderRadius section = BorderRadius.all(Radius.circular(16));
  static const BorderRadius card = BorderRadius.all(Radius.circular(12));
  static const BorderRadius selectorItem = BorderRadius.all(
    Radius.circular(10),
  );
  static const BorderRadius feedback = BorderRadius.all(Radius.circular(8));
  static const BorderRadius control = BorderRadius.all(Radius.circular(10));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}
