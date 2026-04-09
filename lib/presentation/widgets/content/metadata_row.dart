import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/validated_text.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/text_widgets.dart';
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
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: [
        for (final item in items)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SupportingText(text: item.label),
              const SizedBox(height: 4),
              ValidatedText(
                field: item.value,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
      ],
    );
  }
}
