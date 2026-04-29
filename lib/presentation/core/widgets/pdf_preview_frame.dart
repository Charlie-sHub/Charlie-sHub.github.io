import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Renders a static first-page image preview for a PDF-backed asset.
class PdfPreviewFrame extends StatelessWidget {
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
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: _buildPreview(context),
  );

  Widget _buildPreview(BuildContext context) {
    final path = previewImagePath;
    if (path == null || path.isEmpty) {
      return const _PdfPreviewImageFallback();
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
