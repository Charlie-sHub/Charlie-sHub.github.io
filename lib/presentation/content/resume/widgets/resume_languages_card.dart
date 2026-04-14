import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
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
          for (final item in languages) _ResumeLanguageChip(item: item),
        ],
      );
    }
  }
}

class _ResumeLanguageChip extends StatelessWidget {
  const _ResumeLanguageChip({
    required this.item,
  });

  final ResumeLanguageItem item;

  @override
  Widget build(BuildContext context) {
    final languageFailure = item.language.failureOrNull;
    final proficiencyFailure = item.proficiency.isValid
        ? null
        : ValueFailure<String>.invalidResumeLanguageProficiency(
            failedValue: item.proficiency.jsonValue,
          );

    if (languageFailure != null) {
      return FieldFailureWidget(failure: languageFailure);
    }

    if (proficiencyFailure != null) {
      return FieldFailureWidget(failure: proficiencyFailure);
    }

    return DecoratedBox(
      decoration: AppSurfaceStyles.tagDecoration(context),
      child: Padding(
        padding: AppSpacing.tagChipPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.language.getOrCrash(),
              style: AppTextStyles.heading(context),
            ),
            const SizedBox(width: AppSpacing.size8),
            SupportingText(text: item.proficiency.jsonValue),
          ],
        ),
      ),
    );
  }
}
