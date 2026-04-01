import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/resume_language_proficiency.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ResumeLanguageItem',
    () {
      test(
        'is valid with language and proficiency',
        () {
          final item = ResumeLanguageItem(
            language: SingleLineText('English'),
            proficiency: ResumeLanguageProficiency.c2,
          );

          expect(item.isValid, isTrue);
          expect(item.proficiency, ResumeLanguageProficiency.c2);
        },
      );

      test(
        'is invalid when language is invalid',
        () {
          final item = ResumeLanguageItem(
            language: SingleLineText('   '),
            proficiency: ResumeLanguageProficiency.native,
          );

          expect(item.isValid, isFalse);
          expect(item.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
