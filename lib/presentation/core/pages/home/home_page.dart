import 'dart:math' as math;

import 'package:charlie_shub_portfolio/presentation/content/about/about_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/case_studies/case_studies_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/certifications/certifications_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/courses/courses_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/projects/projects_section.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/resume_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/codersrank_supporting_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/profile_summary_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/ambient_background_motion.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/initial_load_reveal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const _appShellWallpaperAsset = 'assets/media/background.jpg';
const _profileSummaryKey = ValueKey<String>('home-profile-summary');
const _mainContentKey = ValueKey<String>('home-main-content');
final _subtleMotionDelay = Duration(
  milliseconds: AppMotion.durationFast.inMilliseconds ~/ 2,
);
const _aboutSectionId = 'about';
const _projectsSectionId = 'projects';
const _certificationsSectionId = 'certifications';
const _caseStudiesSectionId = 'case-studies';
const _coursesSectionId = 'courses';
const _resumeSectionId = 'resume';
const _codersRankSectionId = 'codersrank';

/// Home page for the single-page public portfolio layout.
class PortfolioHomePage extends StatefulWidget {
  /// Creates the portfolio home page.
  const PortfolioHomePage({
    this.initialSectionId,
    super.key,
  });

  /// Optional section identifier used for first-load anchor scrolling.
  final String? initialSectionId;

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final Map<String, GlobalKey> _sectionKeys = <String, GlobalKey>{
    _aboutSectionId: GlobalKey(),
    _projectsSectionId: GlobalKey(),
    _certificationsSectionId: GlobalKey(),
    _caseStudiesSectionId: GlobalKey(),
    _coursesSectionId: GlobalKey(),
    _resumeSectionId: GlobalKey(),
    _codersRankSectionId: GlobalKey(),
  };
  final ValueNotifier<bool> _codersRankShouldPrepare = ValueNotifier(false);
  bool _hasHandledInitialSectionScroll = false;

  @override
  void dispose() {
    _codersRankShouldPrepare.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasHandledInitialSectionScroll) {
      return;
    }

    final normalizedSectionId = _normalizeSectionId(widget.initialSectionId);
    if (normalizedSectionId == null) {
      _hasHandledInitialSectionScroll = true;

      return;
    }

    _hasHandledInitialSectionScroll = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      final sectionContext = _sectionKeys[normalizedSectionId]?.currentContext;
      if (sectionContext == null) {
        return;
      }

      final duration = context.resolveMotionDuration(AppMotion.durationSlow);

      await Scrollable.ensureVisible(
        sectionContext,
        duration: duration,
        curve: context.resolveMotionCurve(AppMotion.curveSmooth),
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    body: Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.canvas),
        AmbientBackgroundMotion(
          delay: _subtleMotionDelay,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_appShellWallpaperAsset),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide =
                  constraints.maxWidth >= AppLayout.homeStickyProfileBreakpoint;

              if (isWide) {
                return _WideHomePageFrame(
                  maxWidth: constraints.maxWidth,
                  maxHeight: constraints.maxHeight,
                  onLowerPageScrollStarted: _requestCodersRankPreparation,
                  sectionKeys: _sectionKeys,
                  shouldPrepareCodersRank: _codersRankShouldPrepare,
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: _handleHomeScrollNotification,
                child: SingleChildScrollView(
                  padding: AppSpacing.pagePadding,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppLayout.maxContentWidth,
                      ),
                      child: _HomePageContent(
                        includeInlineProfileSummary: true,
                        sectionKeys: _sectionKeys,
                        shouldPrepareCodersRank: _codersRankShouldPrepare,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );

  String? _normalizeSectionId(String? value) {
    if (value == null) {
      return null;
    }

    final normalizedValue = value.trim().toLowerCase();
    if (normalizedValue.isEmpty) {
      return null;
    }

    return switch (normalizedValue) {
      'about' => _aboutSectionId,
      'projects' => _projectsSectionId,
      'certifications' => _certificationsSectionId,
      'case-studies' ||
      'case_studies' ||
      'casestudies' => _caseStudiesSectionId,
      'courses' => _coursesSectionId,
      'resume' => _resumeSectionId,
      'codersrank' || 'coders-rank' || 'coders_rank' => _codersRankSectionId,
      _ => null,
    };
  }

  bool _handleHomeScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }

    if (notification.metrics.pixels > 0) {
      _requestCodersRankPreparation();
    }

    return false;
  }

  void _requestCodersRankPreparation() {
    if (_codersRankShouldPrepare.value) {
      return;
    }

    _codersRankShouldPrepare.value = true;
  }
}

class _WideHomePageFrame extends StatefulWidget {
  const _WideHomePageFrame({
    required this.maxWidth,
    required this.maxHeight,
    required this.onLowerPageScrollStarted,
    required this.sectionKeys,
    required this.shouldPrepareCodersRank,
  });

  final double maxWidth;
  final double maxHeight;
  final VoidCallback onLowerPageScrollStarted;
  final Map<String, GlobalKey> sectionKeys;
  final ValueListenable<bool> shouldPrepareCodersRank;

  @override
  State<_WideHomePageFrame> createState() => _WideHomePageFrameState();
}

class _WideHomePageFrameState extends State<_WideHomePageFrame> {
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
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _handleWidePageScrollNotification,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.size24,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          key: _mainContentKey,
                          width: centeredContentWidth,
                          child: _HomePageContent(
                            includeInlineProfileSummary: false,
                            sectionKeys: widget.sectionKeys,
                            shouldPrepareCodersRank:
                                widget.shouldPrepareCodersRank,
                          ),
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
                        key: _profileSummaryKey,
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

  bool _handleWidePageScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }

    if (notification.metrics.pixels > 0) {
      widget.onLowerPageScrollStarted();
    }

    return false;
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent({
    required this.includeInlineProfileSummary,
    required this.sectionKeys,
    required this.shouldPrepareCodersRank,
  });

  final bool includeInlineProfileSummary;
  final Map<String, GlobalKey> sectionKeys;
  final ValueListenable<bool> shouldPrepareCodersRank;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (includeInlineProfileSummary) ...[
        const InitialLoadReveal(
          child: ProfileSummaryCard(key: _profileSummaryKey),
        ),
        const SizedBox(height: AppSpacing.size24),
      ],
      InitialLoadReveal(
        delay: _subtleMotionDelay,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KeyedSubtree(
              key: sectionKeys[_aboutSectionId],
              child: const AboutSection(),
            ),
            const SizedBox(height: AppSpacing.size24),
            KeyedSubtree(
              key: sectionKeys[_projectsSectionId],
              child: const ProjectsSection(),
            ),
            const SizedBox(height: AppSpacing.size24),
            KeyedSubtree(
              key: sectionKeys[_certificationsSectionId],
              child: const CertificationsSection(),
            ),
            const SizedBox(height: AppSpacing.size24),
            KeyedSubtree(
              key: sectionKeys[_caseStudiesSectionId],
              child: const CaseStudiesSection(),
            ),
            const SizedBox(height: AppSpacing.size24),
            KeyedSubtree(
              key: sectionKeys[_coursesSectionId],
              child: const CoursesSection(),
            ),
            const SizedBox(height: AppSpacing.size24),
            KeyedSubtree(
              key: sectionKeys[_resumeSectionId],
              child: const ResumeSection(),
            ),
            const SizedBox(height: AppSpacing.size24),
            KeyedSubtree(
              key: sectionKeys[_codersRankSectionId],
              child: CodersRankSupportingSection(
                shouldPrepare: shouldPrepareCodersRank,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
