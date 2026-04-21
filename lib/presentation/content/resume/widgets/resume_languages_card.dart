import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/widgets/resume_language_chip.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Renders the languages card in the resume section.
class ResumeLanguagesCard extends StatelessWidget {
  /// Creates a resume languages card.
  const ResumeLanguagesCard({
    required this.languages,
    super.key,
  });

  /// The language items to display.
  final List<ResumeLanguageItem> languages;

  @override
  Widget build(BuildContext context) {
    final collectionFailure = collectionFailureOrNull(
      languages,
      minLength: 1,
    );

    if (collectionFailure != null) {
      return FieldFailureWidget(
        failure: collectionFailure,
      );
    } else {
      return Wrap(
        spacing: AppSpacing.size12,
        runSpacing: AppSpacing.size12,
        children: [
          for (final item in languages) ResumeLanguageChip(item: item),
        ],
      );
    }
  }
}
