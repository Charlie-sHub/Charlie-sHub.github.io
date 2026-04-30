import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Renders a static first-page image preview for a PDF-backed asset.
class PdfPreviewFrame extends StatefulWidget {
  /// Creates a static PDF preview frame.
  const PdfPreviewFrame({
    required this.previewImagePath,
    required this.height,
    super.key,
  });

  /// Relative repository path for the static first-page preview image.
  final String? previewImagePath;

  /// Height of the preview frame.
  final double height;

  @override
  State<PdfPreviewFrame> createState() => _PdfPreviewFrameState();
}

class _PdfPreviewFrameState extends State<PdfPreviewFrame> {
  static const _activationViewportMargin = 160.0;

  ScrollPosition? _scrollPosition;
  bool _shouldLoadPreview = false;
  bool _hasCompletedInitialCheck = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachScrollListener();
    _scheduleInitialVisibilityCheck();
  }

  @override
  void didUpdateWidget(covariant PdfPreviewFrame oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.previewImagePath != oldWidget.previewImagePath) {
      _shouldLoadPreview = false;
      _hasCompletedInitialCheck = false;
      _attachScrollListener();
      _scheduleInitialVisibilityCheck();
    }
  }

  @override
  void dispose() {
    _detachScrollListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: widget.height,
    width: double.infinity,
    child: _buildPreview(context),
  );

  Widget _buildPreview(BuildContext context) {
    final path = widget.previewImagePath;
    if (path == null || path.isEmpty) {
      return const _PdfPreviewImageFallback();
    } else if (!_shouldLoadPreview) {
      return const _PdfPreviewImagePlaceholder();
    } else {
      return Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const _PdfPreviewImageFallback(),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          } else {
            return Stack(
              fit: StackFit.expand,
              children: [
                const _PdfPreviewImageFallback(),
                Center(
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      );
    }
  }

  void _attachScrollListener() {
    if (!_hasPreviewPath || _shouldLoadPreview) {
      _detachScrollListener();

      return;
    }

    final scrollableState = Scrollable.maybeOf(context);
    final nextPosition = scrollableState?.position;

    if (_scrollPosition == nextPosition) {
      return;
    }

    _detachScrollListener();
    _scrollPosition = nextPosition;
    _scrollPosition?.addListener(_handleScrollChanged);

    if (_scrollPosition == null) {
      _activatePreview();
    }
  }

  void _detachScrollListener() {
    _scrollPosition?.removeListener(_handleScrollChanged);
    _scrollPosition = null;
  }

  void _handleScrollChanged() {
    _checkPreviewVisibility();
  }

  void _scheduleInitialVisibilityCheck() {
    if (!_hasPreviewPath || _shouldLoadPreview || _hasCompletedInitialCheck) {
      return;
    }

    _hasCompletedInitialCheck = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _checkPreviewVisibility();
    });
  }

  void _checkPreviewVisibility() {
    if (_shouldLoadPreview) {
      return;
    }

    if (_isNearViewport()) {
      _activatePreview();
    }
  }

  void _activatePreview() {
    if (_shouldLoadPreview) {
      return;
    }

    _detachScrollListener();

    if (mounted) {
      setState(() {
        _shouldLoadPreview = true;
      });
    } else {
      _shouldLoadPreview = true;
    }
  }

  bool _isNearViewport() {
    final renderObject = context.findRenderObject();
    final scrollableState = Scrollable.maybeOf(context);
    final viewportRenderObject = scrollableState?.context.findRenderObject();

    if (renderObject is! RenderBox ||
        viewportRenderObject is! RenderBox ||
        !renderObject.hasSize) {
      return false;
    }

    if (!viewportRenderObject.hasSize) {
      return false;
    }

    final targetRect =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;
    final viewportRect =
        viewportRenderObject.localToGlobal(Offset.zero) &
        viewportRenderObject.size;
    final activationRect = viewportRect.inflate(_activationViewportMargin);

    return targetRect.bottom > activationRect.top &&
        targetRect.top < activationRect.bottom;
  }

  bool get _hasPreviewPath {
    final path = widget.previewImagePath;

    return path != null && path.isNotEmpty;
  }
}

/// Finder key for the static PDF-preview fallback body.
const pdfPreviewImageFallbackKey = ValueKey<String>(
  'pdf-preview-image-fallback',
);

class _PdfPreviewImageFallback extends StatelessWidget {
  const _PdfPreviewImageFallback();

  @override
  Widget build(BuildContext context) => ColoredBox(
    key: pdfPreviewImageFallbackKey,
    color: AppColors.surfaceSecondary,
    child: Center(
      child: Padding(
        padding: AppSpacing.contentCardPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.picture_as_pdf_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: AppSpacing.size10),
            const SupportingText(
              text: 'Preview image unavailable',
            ),
          ],
        ),
      ),
    ),
  );
}

class _PdfPreviewImagePlaceholder extends StatelessWidget {
  const _PdfPreviewImagePlaceholder();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.surfaceSecondary,
    child: Center(
      child: Padding(
        padding: AppSpacing.contentCardPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.picture_as_pdf_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: AppSpacing.size10),
            const SupportingText(
              text: 'Preview image loading...',
            ),
          ],
        ),
      ),
    ),
  );
}
