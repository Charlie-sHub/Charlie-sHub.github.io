part of '../project_image_carousel.dart';

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
