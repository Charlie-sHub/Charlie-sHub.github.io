part of '../project_image_carousel.dart';

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
