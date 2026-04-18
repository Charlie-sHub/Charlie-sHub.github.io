import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Shared presentation surface for the optional CodersRank section.
class CodersRankSupportingSectionContent extends StatelessWidget {
  /// Creates the shared CodersRank section content.
  const CodersRankSupportingSectionContent({
    required this.isVisible,
    this.rankWidget = const SizedBox.shrink(),
    super.key,
  });

  /// Whether the section should render at all.
  final bool isVisible;

  /// Rendered rank widget surface.
  final Widget rankWidget;

  @override
  Widget build(BuildContext context) {
    if (isVisible) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionContainer(
            heading: const SectionHeadingText(
              text: 'CodersRank',
              icon: Icons.query_stats_outlined,
            ),
            children: [
              _CodersRankPanel(
                cardKey: const ValueKey<String>('codersrank-rank-panel'),
                child: rankWidget,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.size24),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _CodersRankPanel extends StatelessWidget {
  const _CodersRankPanel({
    required this.cardKey,
    required this.child,
  });

  final Key cardKey;
  final Widget child;

  @override
  Widget build(BuildContext context) => ContentCard(
    key: cardKey,
    child: child,
  );
}
