import 'package:charlie_shub_portfolio/domain/core/entities/about_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'AboutSkillGroup',
    () {
      test(
        'is valid with a label and at least one item',
        () {
          final group = AboutSkillGroup(
            label: SingleLineText('Languages and frameworks'),
            items: <SingleLineText>[SingleLineText('Flutter')],
          );

          expect(group.isValid, isTrue);
        },
      );

      test(
        'is invalid when items are empty',
        () {
          final group = AboutSkillGroup(
            label: SingleLineText('Languages and frameworks'),
            items: const <SingleLineText>[],
          );

          expect(group.isValid, isFalse);
          expect(group.failureOption.isSome(), isTrue);
        },
      );

      test(
        'is invalid when the label breaks the single-line rule',
        () {
          final group = AboutSkillGroup(
            label: SingleLineText('Languages\nand frameworks'),
            items: <SingleLineText>[SingleLineText('Flutter')],
          );

          expect(group.isValid, isFalse);
          expect(group.failureOption.isSome(), isTrue);
          expect(group.failureOrUnit.isLeft(), isTrue);
        },
      );
    },
  );
}
