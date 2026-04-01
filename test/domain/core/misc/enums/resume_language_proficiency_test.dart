import 'package:charlie_shub_portfolio/domain/core/misc/enums/resume_language_proficiency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ResumeLanguageProficiency',
    () {
      test(
        'keeps the current resume proficiency values explicit',
        () {
          expect(
            ResumeLanguageProficiency.values.map((value) => value.jsonValue),
            <String>['Native', 'C2', 'B1'],
          );
        },
      );

      test(
        'parses known resume proficiency strings',
        () {
          expect(
            ResumeLanguageProficiency.fromString('Native'),
            ResumeLanguageProficiency.native,
          );
          expect(
            ResumeLanguageProficiency.fromString('C2'),
            ResumeLanguageProficiency.c2,
          );
          expect(
            ResumeLanguageProficiency.fromString('B1'),
            ResumeLanguageProficiency.b1,
          );
        },
      );

      test(
        'returns null for unsupported proficiency strings',
        () {
          expect(ResumeLanguageProficiency.fromString('advanced'), isNull);
        },
      );
    },
  );
}
