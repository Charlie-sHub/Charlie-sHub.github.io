import 'package:charlie_shub_portfolio/domain/core/misc/enums/language_proficiency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'LanguageProficiency',
    () {
      test(
        'includes the supported CEFR values plus an invalid fallback',
        () {
          expect(
            LanguageProficiency.values.map((value) => value.jsonValue),
            <String>['invalid', 'Native', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2'],
          );
        },
      );

      test(
        'parses known resume proficiency strings',
        () {
          expect(
            LanguageProficiency.fromString('Native'),
            LanguageProficiency.native,
          );
          expect(
            LanguageProficiency.fromString('A1'),
            LanguageProficiency.a1,
          );
          expect(
            LanguageProficiency.fromString('A2'),
            LanguageProficiency.a2,
          );
          expect(
            LanguageProficiency.fromString('B1'),
            LanguageProficiency.b1,
          );
          expect(
            LanguageProficiency.fromString('B2'),
            LanguageProficiency.b2,
          );
          expect(
            LanguageProficiency.fromString('C1'),
            LanguageProficiency.c1,
          );
          expect(
            LanguageProficiency.fromString('C2'),
            LanguageProficiency.c2,
          );
        },
      );

      test(
        'maps unsupported proficiency strings to invalid',
        () {
          expect(
            LanguageProficiency.fromString('advanced'),
            LanguageProficiency.invalid,
          );
        },
      );
    },
  );
}
