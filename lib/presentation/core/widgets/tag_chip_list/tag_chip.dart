part of '../tag_chip_list.dart';

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: AppSurfaceStyles.tagDecoration(context),
    child: Padding(
      padding: AppSpacing.tagChipPadding,
      child: Text(
        label,
        style: AppTextStyles.label(context),
      ),
    ),
  );
}
