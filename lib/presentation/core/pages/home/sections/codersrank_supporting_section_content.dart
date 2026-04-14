import 'package:charlie_shub_portfolio/presentation/core/theme/app_codersrank_theme.dart';
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
    this.activityWidget = const SizedBox.shrink(),
    super.key,
  });

  /// Whether the section should render at all.
  final bool isVisible;

  /// Rendered rank widget surface.
  final Widget rankWidget;

  /// Rendered GitHub activity widget surface.
  final Widget activityWidget;

  @override
  Widget build(BuildContext context) {
    if (isVisible) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionContainer(
            heading: const SectionHeadingText(
              text: 'CodersRank',
            ),
            children: [
              const SupportingText(
                text:
                    'Optional external proof signals that stay secondary to '
                    'the first-party portfolio content above.',
              ),
              const SizedBox(height: AppSpacing.size16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final useRow =
                      constraints.maxWidth >=
                      AppCodersRankTheme.widgetRowBreakpoint;
                  final rankPanel = _CodersRankPanel(
                    cardKey: const ValueKey<String>('codersrank-rank-panel'),
                    title: 'Rank widgets',
                    child: rankWidget,
                  );
                  final activityPanel = _CodersRankPanel(
                    cardKey: const ValueKey<String>(
                      'codersrank-activity-panel',
                    ),
                    title: 'GitHub activity matrix',
                    child: activityWidget,
                  );

                  if (useRow) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: rankPanel),
                        const SizedBox(width: AppSpacing.size16),
                        Expanded(child: activityPanel),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        rankPanel,
                        const SizedBox(height: AppSpacing.size16),
                        activityPanel,
                      ],
                    );
                  }
                },
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
    required this.title,
    required this.child,
  });

  final Key cardKey;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => ContentCard(
    key: cardKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingText(text: title),
        const SizedBox(height: AppSpacing.size12),
        child,
      ],
    ),
  );
}
