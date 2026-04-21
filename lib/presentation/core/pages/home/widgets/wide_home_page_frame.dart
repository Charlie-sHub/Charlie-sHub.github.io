import 'dart:math' as math;

import 'package:charlie_shub_portfolio/presentation/core/pages/home/home_page_constants.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/home_page_content.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/profile_summary_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/initial_load_reveal.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Wide-layout home-page frame with a sticky profile-summary lane.
class WideHomePageFrame extends StatefulWidget {
  /// Creates the wide home-page frame.
  const WideHomePageFrame({
    required this.maxWidth,
    required this.maxHeight,
    required this.sectionKeys,
    super.key,
  });

  /// Available viewport width for the page shell.
  final double maxWidth;

  /// Available viewport height for the page shell.
  final double maxHeight;

  /// Section anchor keys used for first-load scroll targeting.
  final Map<String, GlobalKey> sectionKeys;

  @override
  State<WideHomePageFrame> createState() => _WideHomePageFrameState();
}

class _WideHomePageFrameState extends State<WideHomePageFrame> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _stickySummaryLaneKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const contentSideInset =
        AppSpacing.size24 +
        AppLayout.homeProfileSummaryWidth +
        AppLayout.homeProfileSummaryGap;
    final centeredContentWidth = math.min(
      AppLayout.maxContentWidth,
      widget.maxWidth - (contentSideInset * 2),
    );
    final centeredContentLeftInset =
        (widget.maxWidth - centeredContentWidth) / 2;
    final stickySummaryLeftInset =
        centeredContentLeftInset -
        AppLayout.homeProfileSummaryGap -
        AppLayout.homeProfileSummaryWidth;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: widget.maxWidth,
        height: widget.maxHeight,
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerSignal: _handleWidePagePointerSignal,
          child: PrimaryScrollController(
            controller: _scrollController,
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.size24,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        key: homeMainContentKey,
                        width: centeredContentWidth,
                        child: HomePageContent(
                          includeInlineProfileSummary: false,
                          sectionKeys: widget.sectionKeys,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: stickySummaryLeftInset,
                  top: AppSpacing.size24,
                  child: SizedBox(
                    key: _stickySummaryLaneKey,
                    width: AppLayout.homeProfileSummaryWidth,
                    child: const InitialLoadReveal(
                      child: SizedBox(
                        key: homeProfileSummaryKey,
                        width: AppLayout.homeProfileSummaryWidth,
                        child: ProfileSummaryCard(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleWidePagePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) {
      return;
    }

    if (!_pointerIsInsideStickySummaryLane(event.position)) {
      return;
    }

    if (!_scrollController.hasClients) {
      return;
    }

    _scrollController.position.pointerScroll(event.scrollDelta.dy);
  }

  bool _pointerIsInsideStickySummaryLane(Offset globalPosition) {
    final viewportContext = _stickySummaryLaneKey.currentContext;

    if (viewportContext == null) {
      return false;
    }

    final renderObject = viewportContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return false;
    }

    final viewportRect =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;

    return viewportRect.contains(globalPosition);
  }
}
