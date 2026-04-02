import 'package:charlie_shub_portfolio/domain/core/entities/resume_language_item.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/language_proficiency.dart';
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
            proficiency: LanguageProficiency.c2,
          );

          expect(item.isValid, isTrue);
          expect(item.proficiency, LanguageProficiency.c2);
        },
      );

      test(
        'is invalid when language is invalid',
        () {
          final item = ResumeLanguageItem(
            language: SingleLineText('   '),
            proficiency: LanguageProficiency.native,
          );

          expect(item.isValid, isFalse);
          expect(item.failureOption.isSome(), isTrue);
        },
      );

      test(
        'is invalid when proficiency is outside the supported vocabulary',
        () {
          final item = ResumeLanguageItem(
            language: SingleLineText('English'),
            proficiency: LanguageProficiency.invalid,
          );

          expect(item.isValid, isFalse);
          expect(item.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
