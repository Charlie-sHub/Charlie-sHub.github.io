part of '../link_button.dart';

class _LinkButtonContent extends StatelessWidget {
  const _LinkButtonContent({
    required this.label,
    required this.icon,
    required this.expandLabel,
    required this.balanceTrailingSlot,
    required this.textAlign,
  });

  final String label;
  final IconData icon;
  final bool expandLabel;
  final bool balanceTrailingSlot;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: AppLayout.actionLeadingIconSize,
        child: Icon(
          icon,
          size: AppLayout.actionLeadingIconSize,
        ),
      ),
      const SizedBox(width: AppSpacing.size8),
      if (expandLabel || balanceTrailingSlot)
        Expanded(
          child: Text(
            label,
            textAlign: textAlign,
          ),
        )
      else
        Text(
          label,
          textAlign: textAlign,
        ),
      if (balanceTrailingSlot) ...[
        const SizedBox(width: AppSpacing.size8),
        const SizedBox(width: AppLayout.actionLeadingIconSize),
      ],
    ],
  );
}
