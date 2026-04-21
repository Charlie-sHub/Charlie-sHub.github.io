part of '../project_image_carousel.dart';

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
