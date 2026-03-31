import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'About',
    () {
      test(
        'is valid for a schema-aligned about entry',
        () {
          final about = About(
            slug: Slug('about_me'),
            sourcePath: SingleLineText('sources_of_truth/about_me.md'),
            title: Title('About Me'),
            whoIAmProfessionally: NonEmptyText(
              'Software developer with Flutter experience',
            ),
            currentPositioning: NonEmptyText(
              'Security-oriented software developer',
            ),
            developmentBackground: NonEmptyText(
              'Product development background',
            ),
            securityDirection: NonEmptyText('Growing into secure engineering'),
            strengthsAndWorkingStyle: <NonEmptyText>[
              NonEmptyText('Structured planning before implementation'),
            ],
            selectedSkillsAndTools: <AboutSkillGroup>[
              AboutSkillGroup(
                label: SingleLineText('Languages and frameworks'),
                items: <SingleLineText>[SingleLineText('Flutter')],
              ),
            ],
            howIBuildSoftware: NonEmptyText('Keep responsibilities clear'),
            howDevelopmentAndSecurityConnect: NonEmptyText(
              'Through disciplined engineering',
            ),
          );

          expect(about.isValid, isTrue);
          expect(about.failureOrUnit.isRight(), isTrue);
        },
      );

      test(
        'is invalid when a required collection is empty',
        () {
          final about = About(
            slug: Slug('about_me'),
            sourcePath: SingleLineText('sources_of_truth/about_me.md'),
            title: Title('About Me'),
            whoIAmProfessionally: NonEmptyText(
              'Software developer with Flutter experience',
            ),
            currentPositioning: NonEmptyText(
              'Security-oriented software developer',
            ),
            developmentBackground: NonEmptyText(
              'Product development background',
            ),
            securityDirection: NonEmptyText('Growing into secure engineering'),
            strengthsAndWorkingStyle: const <NonEmptyText>[],
            selectedSkillsAndTools: <AboutSkillGroup>[
              AboutSkillGroup(
                label: SingleLineText('Languages and frameworks'),
                items: <SingleLineText>[SingleLineText('Flutter')],
              ),
            ],
            howIBuildSoftware: NonEmptyText('Keep responsibilities clear'),
            howDevelopmentAndSecurityConnect: NonEmptyText(
              'Through disciplined engineering',
            ),
          );

          expect(about.isValid, isFalse);
          expect(about.failureOption.isSome(), isTrue);
          expect(about.failureOrUnit.isLeft(), isTrue);
        },
      );
    },
  );
}
