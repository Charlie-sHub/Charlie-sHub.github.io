import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_load_completion_scope.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_frame_stub.dart'
    if (dart.library.html) 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_frame_web.dart'
    as impl;
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Renders a lightweight in-page PDF preview where supported.
class PdfPreviewFrame extends StatefulWidget {
  /// Creates a PDF preview frame.
  const PdfPreviewFrame({
    required this.path,
    required this.height,
    super.key,
  });

  /// Relative repository path for the bundled PDF asset.
  final String path;

  /// Height of the preview frame.
  final double height;

  @override
  State<PdfPreviewFrame> createState() => _PdfPreviewFrameState();
}

class _PdfPreviewFrameState extends State<PdfPreviewFrame> {
  bool _didResolveInitialActivation = false;
  bool _shouldInitializePreview = false;
  bool _isPreviewReady = false;
  int _previewGeneration = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final isContentLoadComplete = ContentLoadCompletionScope.isCompleteOf(
      context,
    );
    if (!_didResolveInitialActivation) {
      _didResolveInitialActivation = true;
      _shouldInitializePreview = isContentLoadComplete;

      return;
    }

    if (_shouldInitializePreview != isContentLoadComplete) {
      setState(() {
        _shouldInitializePreview = isContentLoadComplete;

        if (!isContentLoadComplete) {
          _previewGeneration += 1;
          _isPreviewReady = false;
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant PdfPreviewFrame oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.path != widget.path) {
      _previewGeneration += 1;
      _isPreviewReady = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final motionDuration = context.resolveMotionDuration(
      AppMotion.durationStandard,
    );
    final motionCurve = context.resolveMotionCurve(AppMotion.curveSmooth);
    final previewGeneration = _previewGeneration;
    final showLoadingState = !_shouldInitializePreview || !_isPreviewReady;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (_shouldInitializePreview)
          AnimatedOpacity(
            opacity: _isPreviewReady ? 1 : 0,
            duration: motionDuration,
            curve: motionCurve,
            child: impl.buildPdfPreviewFrame(
              path: widget.path,
              height: widget.height,
              onReady: () => _handlePreviewReady(previewGeneration),
            ),
          ),
        IgnorePointer(
          ignoring: !showLoadingState,
          child: AnimatedOpacity(
            opacity: showLoadingState ? 1 : 0,
            duration: motionDuration,
            curve: motionCurve,
            child: const _PdfPreviewLoadingState(),
          ),
        ),
      ],
    );
  }

  void _handlePreviewReady(int previewGeneration) {
    if (_isPreviewReady ||
        !_shouldInitializePreview ||
        !mounted ||
        previewGeneration != _previewGeneration) {
      return;
    }

    setState(() {
      _isPreviewReady = true;
    });
  }
}

const _pdfPreviewLoadingStateKey = ValueKey<String>(
  'pdf-preview-loading-state',
);

class _PdfPreviewLoadingState extends StatelessWidget {
  const _PdfPreviewLoadingState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      key: _pdfPreviewLoadingStateKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppSpacing.size10),
          const SupportingText(text: 'Loading preview...'),
        ],
      ),
    );
  }
}
