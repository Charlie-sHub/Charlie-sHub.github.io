import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// One language chip inside the resume languages wrap.
class ResumeLanguageChip extends StatelessWidget {
  /// Creates a resume language chip.
  const ResumeLanguageChip({
    required this.item,
    super.key,
  });

  /// The language item to render.
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
              style: AppTextStyles.contentTitleCompact(context),
            ),
            const SizedBox(width: AppSpacing.size8),
            SupportingText(text: item.proficiency.jsonValue),
          ],
        ),
      ),
    );
  }
}
