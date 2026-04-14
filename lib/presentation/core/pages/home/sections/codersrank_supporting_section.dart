import 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/codersrank_supporting_section_stub.dart'
    if (dart.library.html) 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/codersrank_supporting_section_web.dart'
    as impl;
import 'package:flutter/widgets.dart';

/// Optional home-page CodersRank section.
class CodersRankSupportingSection extends StatelessWidget {
  /// Creates the optional home-page CodersRank section.
  const CodersRankSupportingSection({super.key});

  @override
  Widget build(BuildContext context) => impl.buildCodersRankSupportingSection();
}
