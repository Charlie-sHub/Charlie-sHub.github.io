import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Builds the CodersRank section for platforms that do not support it.
Widget buildCodersRankSupportingSection({
  required ValueListenable<bool> shouldPrepare,
}) => const SizedBox.shrink();
