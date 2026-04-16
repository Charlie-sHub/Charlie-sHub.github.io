import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entry_selector_labels.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Builds the selector label for one case-study entry.
class CaseStudySelectorLabel extends StatelessWidget {
  /// Creates a case-study selector label.
  const CaseStudySelectorLabel({
    required this.item,
    required this.isSelected,
    super.key,
  });

  /// The case-study load item represented in the selector.
  final SectionItemLoad<CaseStudy> item;

  /// Whether this selector item is currently selected.
  final bool isSelected;

  @override
  Widget build(BuildContext context) => item.fold(
    (_) => UnavailableEntrySelectorLabel(
      title: 'Unavailable case study',
      isSelected: isSelected,
    ),
    (caseStudy) => EntrySelectorLabel(
      title: ValidatedText(
        field: caseStudy.title,
        style: AppTextStyles.selectorTitleState(
          context,
          isSelected: isSelected,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: caseStudy.incidentCode == null
          ? ValidatedText(
              field: caseStudy.summary,
              style: AppTextStyles.selectorSupporting(context),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : ValidatedText(
              field: caseStudy.incidentCode!,
              style: AppTextStyles.selectorSupporting(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
    ),
  );
}
