import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification_credential_details.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Certification',
    () {
      test(
        'is valid for a schema-aligned certification shape',
        () {
          final certification = Certification(
            slug: Slug('comptia_security_plus'),
            sourcePath: SingleLineText(
              'security/certifications/comptia/comptia_security_plus.md',
            ),
            earnedDate: YearMonth('2026-03'),
            title: Title('CompTIA Security+'),
            summary: NonEmptyText('Vendor-neutral cybersecurity certification'),
            certificatePdfPath: DocumentPath(
              'assets/documents/certifications/comptia_security_plus_ce_certificate.pdf',
            ),
            credentialDetails: CertificationCredentialDetails(
              issuer: SingleLineText('CompTIA'),
              credentialType: SingleLineText('cybersecurity certification'),
              level: SingleLineText('entry to intermediate'),
              version: SingleLineText('Security+ (SY0-701)'),
            ),
            knowledgeAreas: <NonEmptyText>[
              NonEmptyText('General security concepts'),
            ],
            learningOutcomes: <NonEmptyText>[
              NonEmptyText('Analyze common cyber threats'),
            ],
            proof: <LinkReference>[
              LinkReference(
                label: SingleLineText('Credly badge'),
                url: UrlValue('https://www.credly.com/badges/example'),
              ),
            ],
          );

          expect(certification.isValid, isTrue);
        },
      );

      test(
        'is invalid when a required collection is empty',
        () {
          final certification = Certification(
            slug: Slug('comptia_security_plus'),
            sourcePath: SingleLineText(
              'security/certifications/comptia/comptia_security_plus.md',
            ),
            earnedDate: YearMonth('2026-03'),
            title: Title('CompTIA Security+'),
            summary: NonEmptyText('Vendor-neutral cybersecurity certification'),
            credentialDetails: CertificationCredentialDetails(
              issuer: SingleLineText('CompTIA'),
              credentialType: SingleLineText('cybersecurity certification'),
              level: SingleLineText('entry to intermediate'),
            ),
            knowledgeAreas: const <NonEmptyText>[],
            learningOutcomes: <NonEmptyText>[
              NonEmptyText('Analyze common cyber threats'),
            ],
          );

          expect(certification.isValid, isFalse);
          expect(certification.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
