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
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const _appShellWallpaperAsset = 'assets/media/background.jpg';
const _profileSummaryKey = ValueKey<String>('home-profile-summary');

/// Home page for the single-page public portfolio layout.
class PortfolioHomePage extends StatelessWidget {
  /// Creates the portfolio home page.
  const PortfolioHomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    body: Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.canvas),
        const DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_appShellWallpaperAsset),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
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
                );
              }

              return SingleChildScrollView(
                padding: AppSpacing.pagePadding,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppLayout.maxContentWidth,
                    ),
                    child: const _HomePageContent(
                      includeInlineProfileSummary: true,
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
}

class _WideHomePageFrame extends StatefulWidget {
  const _WideHomePageFrame({
    required this.maxWidth,
    required this.maxHeight,
  });

  final double maxWidth;
  final double maxHeight;

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
    final frameWidth = math.min(
      widget.maxWidth,
      AppLayout.maxHomeContentWidth + AppSpacing.pagePadding.horizontal,
    );
    final frameLeftInset = (widget.maxWidth - frameWidth) / 2;

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
                        width: frameWidth,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left:
                                AppSpacing.size24 +
                                AppLayout.homeProfileSummaryWidth +
                                AppLayout.homeProfileSummaryGap,
                            right: AppSpacing.size24,
                          ),
                          child: _HomePageContent(
                            includeInlineProfileSummary: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: frameLeftInset + AppSpacing.size24,
                  top: AppSpacing.size24,
                  child: SizedBox(
                    key: _stickySummaryLaneKey,
                    width: AppLayout.homeProfileSummaryWidth,
                    child: const SizedBox(
                      key: _profileSummaryKey,
                      width: AppLayout.homeProfileSummaryWidth,
                      child: ProfileSummaryCard(),
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

class _HomePageContent extends StatelessWidget {
  const _HomePageContent({
    required this.includeInlineProfileSummary,
  });

  final bool includeInlineProfileSummary;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (includeInlineProfileSummary) ...[
        const ProfileSummaryCard(key: _profileSummaryKey),
        const SizedBox(height: AppSpacing.size24),
      ],
      const AboutSection(),
      const SizedBox(height: AppSpacing.size24),
      const ProjectsSection(),
      const SizedBox(height: AppSpacing.size24),
      const CertificationsSection(),
      const SizedBox(height: AppSpacing.size24),
      const CaseStudiesSection(),
      const SizedBox(height: AppSpacing.size24),
      const CoursesSection(),
      const SizedBox(height: AppSpacing.size24),
      const ResumeSection(),
      const SizedBox(height: AppSpacing.size24),
      const CodersRankSupportingSection(),
    ],
  );
}
