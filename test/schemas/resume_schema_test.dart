import 'dart:convert';
import 'dart:io';

import 'package:charlie_shub_portfolio/domain/core/misc/enums/language_proficiency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'resume.schema.json',
    () {
      test(
        'matches the supported domain language proficiency vocabulary',
        () {
          final schema =
              jsonDecode(
                    File('schemas/resume.schema.json').readAsStringSync(),
                  )
                  as Map<String, dynamic>;
          final definitions = schema[r'$defs'] as Map<String, dynamic>;
          final proficiencyValue =
              definitions['language_proficiency_value'] as Map<String, dynamic>;

          expect(
            proficiencyValue['enum'],
            LanguageProficiency.supportedJsonValues,
          );
        },
      );
    },
  );
}
