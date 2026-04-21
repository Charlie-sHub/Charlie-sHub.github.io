import 'package:charlie_shub_portfolio/presentation/core/pages/home/home_page_constants.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/home_page_content.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/wide_home_page_frame.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/ambient_background_motion.dart';
import 'package:flutter/material.dart';

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
    aboutSectionId: GlobalKey(),
    projectsSectionId: GlobalKey(),
    certificationsSectionId: GlobalKey(),
    caseStudiesSectionId: GlobalKey(),
    coursesSectionId: GlobalKey(),
    resumeSectionId: GlobalKey(),
    codersRankSectionId: GlobalKey(),
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
          delay: homeSubtleMotionDelay,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(homeAppShellWallpaperAsset),
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
                return WideHomePageFrame(
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
                      child: HomePageContent(
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
      'about' => aboutSectionId,
      'projects' => projectsSectionId,
      'certifications' => certificationsSectionId,
      'case-studies' || 'case_studies' || 'casestudies' => caseStudiesSectionId,
      'courses' => coursesSectionId,
      'resume' => resumeSectionId,
      'codersrank' || 'coders-rank' || 'coders_rank' => codersRankSectionId,
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
