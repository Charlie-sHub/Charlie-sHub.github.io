import 'dart:async';

import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_asset_media_card.dart';
import 'package:flutter/material.dart';

/// Displays project images in a compact carousel with an enlarged viewer.
class ProjectImageCarousel extends StatefulWidget {
  /// Creates a project image carousel.
  const ProjectImageCarousel({
    required this.imagePaths,
    super.key,
  });

  /// The ordered project images to show.
  final List<AssetPath> imagePaths;

  @override
  State<ProjectImageCarousel> createState() => _ProjectImageCarouselState();
}

class _ProjectImageCarouselState extends State<ProjectImageCarousel> {
  late final PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant ProjectImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.imagePaths.isEmpty) {
      _selectedIndex = 0;

      return;
    }

    final maxIndex = widget.imagePaths.length - 1;
    if (_selectedIndex > maxIndex) {
      _selectedIndex = maxIndex;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_pageController.hasClients) {
          return;
        }

        _pageController.jumpToPage(_selectedIndex);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    final hasMultipleImages = widget.imagePaths.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppLayout.mediaHeroHeight,
          child: Stack(
            children: [
              PageView.builder(
                key: const ValueKey<String>('project-image-carousel'),
                controller: _pageController,
                itemCount: widget.imagePaths.length,
                onPageChanged: _handlePageChanged,
                itemBuilder: (context, index) => ValidatedAssetMediaCard(
                  path: widget.imagePaths[index],
                  labelBuilder: _buildImageLabel,
                  height: AppLayout.mediaHeroHeight,
                  fit: BoxFit.contain,
                  onTap: () => _openViewer(index),
                  tooltip: _buildOpenImageTooltip(
                    index: index,
                    totalCount: widget.imagePaths.length,
                  ),
                ),
              ),
              if (hasMultipleImages) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.size12),
                    child: _CarouselNavigationButton(
                      tooltip: 'Previous image',
                      icon: Icons.chevron_left_rounded,
                      onPressed: _showPreviousImage,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.size12),
                    child: _CarouselNavigationButton(
                      tooltip: 'Next image',
                      icon: Icons.chevron_right_rounded,
                      onPressed: _showNextImage,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.size12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SupportingText(
              text:
                  'Image ${_selectedIndex + 1} of ${widget.imagePaths.length}',
            ),
            if (hasMultipleImages) ...[
              const SizedBox(width: AppSpacing.size12),
              _CarouselPageIndicators(
                itemCount: widget.imagePaths.length,
                selectedIndex: _selectedIndex,
              ),
            ],
          ],
        ),
      ],
    );
  }

  static String _buildImageLabel(String value) =>
      'Project image available: ${value.split('/').last}';

  static String _buildOpenImageTooltip({
    required int index,
    required int totalCount,
  }) => 'Open image ${index + 1} of $totalCount';

  Future<void> _openViewer(int index) async {
    await showDialog<void>(
      context: context,
      builder: (context) => _ProjectImageViewerDialog(
        imagePath: widget.imagePaths[index],
        imageLabel: 'Image ${index + 1} of ${widget.imagePaths.length}',
      ),
    );
  }

  void _handlePageChanged(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _showNextImage() {
    if (widget.imagePaths.isEmpty) {
      return;
    }

    final nextIndex = (_selectedIndex + 1) % widget.imagePaths.length;
    _moveToPage(nextIndex);
  }

  void _showPreviousImage() {
    if (widget.imagePaths.isEmpty) {
      return;
    }

    final previousIndex =
        (_selectedIndex - 1 + widget.imagePaths.length) %
        widget.imagePaths.length;
    _moveToPage(previousIndex);
  }

  void _moveToPage(int index) {
    if (!_pageController.hasClients) {
      return;
    }

    if (context.prefersReducedMotion) {
      _pageController.jumpToPage(index);
    } else {
      unawaited(
        _pageController.animateToPage(
          index,
          duration: AppMotion.durationStandard,
          curve: AppMotion.curveStandard,
        ),
      );
    }
  }
}

class _CarouselNavigationButton extends StatelessWidget {
  const _CarouselNavigationButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.surface.withValues(alpha: 0.92),
          foregroundColor: colorScheme.onSurface,
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}

class _CarouselPageIndicators extends StatelessWidget {
  const _CarouselPageIndicators({
    required this.itemCount,
    required this.selectedIndex,
  });

  final int itemCount;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final indicatorDuration = context.resolveMotionDuration(
      AppMotion.durationFast,
    );
    final indicatorCurve = context.resolveMotionCurve(AppMotion.curveStandard);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: indicatorDuration,
          curve: indicatorCurve,
          margin: EdgeInsets.only(
            left: index == 0 ? AppSpacing.zero.left : AppSpacing.size6,
          ),
          width: index == selectedIndex ? AppSpacing.size12 : AppSpacing.size8,
          height: AppSpacing.size8,
          decoration: BoxDecoration(
            borderRadius: AppRadii.pill,
            color: index == selectedIndex
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}

class _ProjectImageViewerDialog extends StatelessWidget {
  const _ProjectImageViewerDialog({
    required this.imagePath,
    required this.imageLabel,
  });

  final AssetPath imagePath;
  final String imageLabel;

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.all(AppSpacing.size24),
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: AppLayout.maxContentWidth,
        maxHeight: AppLayout.mediaViewerMaxHeight,
      ),
      child: ContentCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SupportingText(text: imageLabel),
                ),
                Tooltip(
                  message: 'Close image viewer',
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.size12),
            Flexible(
              child: imagePath.value.fold(
                (failure) => FieldFailureWidget(failure: failure),
                (value) => ClipRRect(
                  borderRadius: AppRadii.card,
                  child: ColoredBox(
                    color: AppColors.surfaceSecondary,
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: Center(
                        child: Image.asset(
                          value,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (
                                context,
                                error,
                                stackTrace,
                              ) => const _ProjectImageViewerFallback(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ProjectImageViewerFallback extends StatelessWidget {
  const _ProjectImageViewerFallback();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.size24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              color: colorScheme.secondary,
            ),
            const SizedBox(height: AppSpacing.size12),
            const SupportingText(text: 'Project image unavailable'),
          ],
        ),
      ),
    );
  }
}
