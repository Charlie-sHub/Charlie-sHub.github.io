import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/language_proficiency.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/widgets/resume_languages_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../application/content/content_test_entity_builders.dart';
import '../../../core/presentation_test_helpers.dart';

void main() {
  group(
    'ResumeLanguagesCard',
    () {
      testWidgets(
        'renders valid language rows without failure widgets',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ResumeLanguagesCard(
                languages: buildResume().languages,
              ),
            ),
          );

          expect(find.text('English'), findsOneWidget);
          expect(find.text('C1'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders a failure widget for unsupported language proficiency',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ResumeLanguagesCard(
                languages: <ResumeLanguageItem>[
                  ResumeLanguageItem(
                    language: SingleLineText('English'),
                    proficiency: LanguageProficiency.invalid,
                  ),
                ],
              ),
            ),
          );

          expect(find.text('English'), findsOneWidget);
          expect(find.text('C1'), findsNothing);
          expect(find.byType(FieldFailureWidget), findsOneWidget);
        },
      );

      testWidgets(
        'renders a collection failure when languages are missing',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const ResumeLanguagesCard(
                languages: <ResumeLanguageItem>[],
              ),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.text('English'), findsNothing);
        },
      );
    },
  );
}
