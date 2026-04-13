import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Describes one metadata item shown in a metadata row.
class MetadataItemData {
  /// Creates metadata item data.
  const MetadataItemData({
    required this.label,
    required this.value,
  });

  /// The metadata label.
  final String label;

  /// The validated value for the metadata item.
  final ValueObject<String> value;
}

/// Renders repeated metadata label/value pairs in a responsive wrap layout.
class MetadataRow extends StatelessWidget {
  /// Creates a metadata row.
  const MetadataRow({
    required this.items,
    super.key,
  });

  /// The metadata items to render.
  final List<MetadataItemData> items;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.size16,
    runSpacing: AppSpacing.size12,
    children: [
      for (final item in items)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.label,
              style: AppTextStyles.metadataLabel(context),
            ),
            const SizedBox(height: AppSpacing.size4),
            ValidatedText(
              field: item.value,
              style: AppTextStyles.bodyCompact(context),
            ),
          ],
        ),
    ],
  );
}
