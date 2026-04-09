import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/presentation/sections/certifications_section.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/content/media_placeholder.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/field_failure_widget.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../application/content/content_test_entity_builders.dart';
import '../presentation_test_helpers.dart';

void main() {
  group(
    'CertificationsSection',
    () {
      testWidgets(
        'renders valid certification content',
        (tester) async {
          final certification = buildCertification().copyWith(
            badgeImagePath: AssetPath(
              'assets/media/content/certifications/security_plus/badge.png',
            ),
            certificatePdfPath: DocumentPath(
              'assets/documents/certifications/security_plus.pdf',
            ),
            proof: <LinkReference>[
              LinkReference(
                label: SingleLineText('Credential proof'),
                url: UrlValue('https://example.com/certification'),
              ),
            ],
          );

          await pumpWithContentState(
            tester,
            child: const CertificationsSection(),
            state: _certificationsState(
              right(<SectionItemLoad<Certification>>[
                right(certification),
              ]),
            ),
          );

          expect(find.text('Security+'), findsOneWidget);
          expect(find.text('A certification summary.'), findsOneWidget);
          expect(find.text('CompTIA'), findsOneWidget);
          expect(find.byType(MediaPlaceholder), findsNWidgets(2));
          expect(find.text('Credential proof'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'does not render optional certificate placeholder when path is absent',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const CertificationsSection(),
            state: _certificationsState(
              right(<SectionItemLoad<Certification>>[
                right(buildCertification()),
              ]),
            ),
          );

          expect(find.byType(MediaPlaceholder), findsNothing);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders field failure when certificatePdfPath is invalid',
        (tester) async {
          final certification = buildCertification().copyWith(
            certificatePdfPath: DocumentPath('invalid/document.pdf'),
          );

          await pumpWithContentState(
            tester,
            child: const CertificationsSection(),
            state: _certificationsState(
              right(<SectionItemLoad<Certification>>[
                right(certification),
              ]),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.byType(MediaPlaceholder), findsNothing);
          expect(find.text('A certification summary.'), findsOneWidget);
        },
      );

      testWidgets(
        'renders a collection failure for missing required certification lists',
        (tester) async {
          final certification = buildCertification().copyWith(
            knowledgeAreas: <NonEmptyText>[],
          );

          await pumpWithContentState(
            tester,
            child: const CertificationsSection(),
            state: _certificationsState(
              right(<SectionItemLoad<Certification>>[
                right(certification),
              ]),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.text('Threats and vulnerabilities.'), findsNothing);
          expect(
            find.text('Strengthened baseline security knowledge.'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders item-level failures inline inside a successful section',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const CertificationsSection(),
            state: _certificationsState(
              right(<SectionItemLoad<Certification>>[
                right(buildCertification()),
                const Left<AppFailure, Certification>(
                  AppFailure.assetNotFound(
                    path: 'assets/content/certifications/missing.json',
                  ),
                ),
              ]),
            ),
          );

          expect(find.text('Security+'), findsOneWidget);
          expect(find.byType(AppFailureCard), findsOneWidget);
          expect(
            find.textContaining('assets/content/certifications/missing.json'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders section-level failure without certification content',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const CertificationsSection(),
            state: _certificationsState(
              left(
                const AppFailure.assetNotFound(
                  path: 'assets/content/certifications/index.json',
                ),
              ),
            ),
          );

          expect(find.byType(AppFailureCard), findsOneWidget);
          expect(find.text('Security+'), findsNothing);
          expect(
            find.text('Certifications section unavailable'),
            findsOneWidget,
          );
        },
      );
    },
  );
}

ContentState _certificationsState(
  MultiEntrySectionLoad<Certification> certificationsLoad,
) => ContentState.initial().copyWith(
  status: ContentStatus.loaded,
  certificationsOption: some(certificationsLoad),
);
