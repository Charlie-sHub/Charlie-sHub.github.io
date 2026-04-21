part of '../validated_asset_media_card.dart';

class _MediaFallbackBody extends StatelessWidget {
  const _MediaFallbackBody({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.size16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: colorScheme.secondary,
            ),
            const SizedBox(height: AppSpacing.size12),
            SupportingText(text: label),
          ],
        ),
      ),
    );
  }
}
