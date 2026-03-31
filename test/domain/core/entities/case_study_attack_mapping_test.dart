import 'package:charlie_shub_portfolio/domain/core/entities/case_study_attack_mapping.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'CaseStudyAttackMapping',
    () {
      test(
        'is valid with populated tactic, technique, and procedure lists',
        () {
          final mapping = CaseStudyAttackMapping(
            tactics: <NonEmptyText>[NonEmptyText('Initial Access [TA0001]')],
            techniques: <NonEmptyText>[
              NonEmptyText('Supply Chain Compromise [T1195]'),
            ],
            procedureExamples: <NonEmptyText>[
              NonEmptyText('Trojanized vendor update'),
            ],
          );

          expect(mapping.isValid, isTrue);
        },
      );

      test(
        'is invalid when a required list is empty',
        () {
          final mapping = CaseStudyAttackMapping(
            tactics: <NonEmptyText>[NonEmptyText('Initial Access [TA0001]')],
            techniques: const <NonEmptyText>[],
            procedureExamples: <NonEmptyText>[
              NonEmptyText('Trojanized vendor update'),
            ],
          );

          expect(mapping.isValid, isFalse);
          expect(mapping.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
