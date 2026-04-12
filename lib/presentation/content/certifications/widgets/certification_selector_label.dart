import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entry_selector_labels.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Builds the selector label for one certification entry.
class CertificationSelectorLabel extends StatelessWidget {
  /// Creates a certification selector label.
  const CertificationSelectorLabel({
    required this.item,
    required this.isSelected,
    super.key,
  });

  /// The certification load item represented in the selector.
  final SectionItemLoad<Certification> item;

  /// Whether this selector item is currently selected.
  final bool isSelected;

  @override
  Widget build(BuildContext context) => item.fold(
    (_) => UnavailableEntrySelectorLabel(
      title: 'Unavailable certification',
      isSelected: isSelected,
    ),
    (certification) => EntrySelectorLabel(
      title: ValidatedText(
        field: certification.title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: ValidatedText(
        field: certification.credentialDetails.issuer,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
