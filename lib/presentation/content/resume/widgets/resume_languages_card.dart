import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
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
      final children = <Widget>[];

      for (var index = 0; index < languages.length; index++) {
        children.add(
          _ResumeLanguageRow(item: languages[index]),
        );

        if (index < languages.length - 1) {
          children.add(const SizedBox(height: 12));
        }
      }

      return ContentCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
    }
  }
}

class _ResumeLanguageRow extends StatelessWidget {
  const _ResumeLanguageRow({
    required this.item,
  });

  final ResumeLanguageItem item;

  @override
  Widget build(BuildContext context) {
    final proficiencyFailure = item.proficiency.isValid
        ? null
        : ValueFailure<String>.invalidResumeLanguageProficiency(
            failedValue: item.proficiency.jsonValue,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValidatedText(
          field: item.language,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        if (proficiencyFailure == null)
          SupportingText(text: item.proficiency.jsonValue)
        else
          FieldFailureWidget(failure: proficiencyFailure),
      ],
    );
  }
}
