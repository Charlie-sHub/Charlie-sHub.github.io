part of '../project_image_carousel.dart';

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
