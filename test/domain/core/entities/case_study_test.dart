import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study_attack_mapping.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'CaseStudy',
    () {
      test(
        'is valid for a schema-aligned case study shape',
        () {
          final caseStudy = CaseStudy(
            slug: Slug('notpetya'),
            sourcePath: SingleLineText(
              'security/case_studies/notpetya_case_study.md',
            ),
            title: Title('NotPetya [S0368]'),
            summary: NonEmptyText(
              'One of the most impactful cyberattacks in history',
            ),
            incidentOverview: NonEmptyText(
              'Supply chain compromise of M.E.Doc',
            ),
            adversaryObjectives: NonEmptyText(
              'Large-scale disruption and economic damage',
            ),
            attackMapping: CaseStudyAttackMapping(
              tactics: <NonEmptyText>[NonEmptyText('Impact [TA0040]')],
              techniques: <NonEmptyText>[
                NonEmptyText('Supply Chain Compromise [T1195]'),
              ],
              procedureExamples: <NonEmptyText>[
                NonEmptyText('Trojanized software update'),
              ],
            ),
            incidentCode: SingleLineText('S0368'),
            defensiveAnalysis: NonEmptyText(
              'Third-party software trust and segmentation mattered',
            ),
            lessonsLearned: <NonEmptyText>[
              NonEmptyText('Backups must be isolated'),
            ],
            reflection: NonEmptyText('Useful reminder about supply-chain risk'),
            references: <LinkReference>[
              LinkReference(
                label: SingleLineText('MITRE ATT&CK'),
                url: UrlValue('https://attack.mitre.org/software/S0368/'),
              ),
            ],
          );

          expect(caseStudy.isValid, isTrue);
        },
      );

      test(
        'is invalid when references are empty',
        () {
          final caseStudy = CaseStudy(
            slug: Slug('notpetya'),
            sourcePath: SingleLineText(
              'security/case_studies/notpetya_case_study.md',
            ),
            title: Title('NotPetya [S0368]'),
            summary: NonEmptyText(
              'One of the most impactful cyberattacks in history',
            ),
            incidentOverview: NonEmptyText(
              'Supply chain compromise of M.E.Doc',
            ),
            adversaryObjectives: NonEmptyText(
              'Large-scale disruption and economic damage',
            ),
            attackMapping: CaseStudyAttackMapping(
              tactics: <NonEmptyText>[NonEmptyText('Impact [TA0040]')],
              techniques: <NonEmptyText>[
                NonEmptyText('Supply Chain Compromise [T1195]'),
              ],
              procedureExamples: <NonEmptyText>[
                NonEmptyText('Trojanized software update'),
              ],
            ),
            incidentCode: SingleLineText('S0368'),
            defensiveAnalysis: NonEmptyText(
              'Third-party software trust and segmentation mattered',
            ),
            lessonsLearned: <NonEmptyText>[
              NonEmptyText('Backups must be isolated'),
            ],
            reflection: NonEmptyText('Useful reminder about supply-chain risk'),
            references: const <LinkReference>[],
          );

          expect(caseStudy.isValid, isFalse);
          expect(caseStudy.failureOption.isSome(), isTrue);
        },
      );

      test(
        'allows a missing incident code when the schema does not require it',
        () {
          final caseStudy = CaseStudy(
            slug: Slug('notpetya'),
            sourcePath: SingleLineText(
              'security/case_studies/notpetya_case_study.md',
            ),
            title: Title('NotPetya'),
            summary: NonEmptyText(
              'One of the most impactful cyberattacks in history',
            ),
            incidentOverview: NonEmptyText(
              'Supply chain compromise of M.E.Doc',
            ),
            adversaryObjectives: NonEmptyText(
              'Large-scale disruption and economic damage',
            ),
            attackMapping: CaseStudyAttackMapping(
              tactics: <NonEmptyText>[NonEmptyText('Impact [TA0040]')],
              techniques: <NonEmptyText>[
                NonEmptyText('Supply Chain Compromise [T1195]'),
              ],
              procedureExamples: <NonEmptyText>[
                NonEmptyText('Trojanized software update'),
              ],
            ),
            defensiveAnalysis: NonEmptyText(
              'Third-party software trust and segmentation mattered',
            ),
            lessonsLearned: <NonEmptyText>[
              NonEmptyText('Backups must be isolated'),
            ],
            reflection: NonEmptyText('Useful reminder about supply-chain risk'),
            references: <LinkReference>[
              LinkReference(
                label: SingleLineText('MITRE ATT&CK'),
                url: UrlValue('https://attack.mitre.org/software/S0368/'),
              ),
            ],
          );

          expect(caseStudy.isValid, isTrue);
          expect(caseStudy.failureOrUnit.isRight(), isTrue);
        },
      );
    },
  );
}
