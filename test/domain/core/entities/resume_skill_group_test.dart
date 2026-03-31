import 'package:charlie_shub_portfolio/domain/core/entities/resume_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ResumeSkillGroup',
    () {
      test(
        'is valid with a label and items',
        () {
          final group = ResumeSkillGroup(
            label: SingleLineText('Languages & Frameworks'),
            items: <SingleLineText>[SingleLineText('Flutter')],
          );

          expect(group.isValid, isTrue);
        },
      );

      test(
        'is invalid when items are empty',
        () {
          final group = ResumeSkillGroup(
            label: SingleLineText('Languages & Frameworks'),
            items: const <SingleLineText>[],
          );

          expect(group.isValid, isFalse);
          expect(group.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
