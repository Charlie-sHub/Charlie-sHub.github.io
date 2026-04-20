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
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart'
    as content_title;
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/presentation/content/certifications/certifications_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_tile.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_asset_media_card.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../application/content/content_test_entity_builders.dart';
import '../../core/presentation_test_helpers.dart';

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
              'assets/documents/certifications/comptia_security_plus_ce_certificate.pdf',
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

          expect(find.text('Security+'), findsNWidgets(2));
          expect(find.text('A certification summary.'), findsOneWidget);
          expect(find.text('CompTIA'), findsNWidgets(2));
          expect(find.byType(AssetMediaCard), findsOneWidget);
          expect(find.byType(PdfPreviewTile), findsOneWidget);
          expect(find.text('View details'), findsOneWidget);
          expect(find.text('Credential proof'), findsNothing);
          await tester.ensureVisible(find.text('View details'));
          await tester.tap(find.text('View details'));
          await tester.pump();
          expect(find.text('Hide details'), findsOneWidget);
          expect(find.text('Credential proof'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'switches visible detail content when another entry is selected',
        (tester) async {
          final firstCertification = buildCertification();
          final secondCertification = buildCertification().copyWith(
            title: content_title.Title('Network+'),
            summary: NonEmptyText('A second certification summary.'),
            credentialDetails: buildCertification().credentialDetails.copyWith(
              issuer: SingleLineText('Cisco'),
            ),
          );

          await pumpWithContentState(
            tester,
            child: const CertificationsSection(),
            state: _certificationsState(
              right(<SectionItemLoad<Certification>>[
                right(firstCertification),
                right(secondCertification),
              ]),
            ),
          );

          expect(find.text('A certification summary.'), findsOneWidget);
          expect(find.text('A second certification summary.'), findsNothing);

          await tester.tap(
            find.byKey(const ValueKey<String>('entry-selector-item-1')),
          );
          await tester.pumpAndSettle();

          expect(find.text('A certification summary.'), findsNothing);
          expect(
            find.text('A second certification summary.'),
            findsOneWidget,
          );
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

          expect(find.byType(AssetMediaCard), findsNothing);
          expect(find.byType(PdfPreviewTile), findsNothing);
          expect(find.text('View details'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'places View details directly below the PDF preview',
        (tester) async {
          final certification = buildCertification().copyWith(
            certificatePdfPath: DocumentPath(
              'assets/documents/certifications/comptia_security_plus_ce_certificate.pdf',
            ),
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

          final previewRect = tester.getRect(find.byType(PdfPreviewTile));
          final buttonRect = tester.getRect(find.text('View details'));

          expect(buttonRect.top, greaterThan(previewRect.bottom));
        },
      );

      testWidgets(
        'uses disclosure controls for long certification summaries',
        (tester) async {
          final certification = buildCertification().copyWith(
            summary: NonEmptyText(_buildLongText()),
          );

          await pumpWithContentState(
            tester,
            child: const CertificationsSection(),
            state: _certificationsState(
              right(<SectionItemLoad<Certification>>[
                right(certification),
              ]),
            ),
            width: 360,
          );

          expect(find.text('Read more'), findsOneWidget);
          expect(find.text('Show less'), findsNothing);

          await tester.tap(find.text('Read more'));
          await tester.pump();

          expect(find.text('Show less'), findsOneWidget);
          expect(find.text('Read more'), findsNothing);
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
          expect(find.byType(PdfPreviewTile), findsNothing);
          expect(find.text('A certification summary.'), findsOneWidget);
        },
      );

      testWidgets(
        'defaults to the first available valid entry when earlier items fail',
        (tester) async {
          final certification = buildCertification().copyWith(
            summary: NonEmptyText('Selected valid certification.'),
          );

          await pumpWithContentState(
            tester,
            child: const CertificationsSection(),
            state: _certificationsState(
              right(<SectionItemLoad<Certification>>[
                const Left<AppFailure, Certification>(
                  AppFailure.assetNotFound(
                    path: 'assets/content/certifications/first_missing.json',
                  ),
                ),
                right(certification),
              ]),
            ),
          );

          expect(find.text('Unavailable certification'), findsOneWidget);
          expect(find.byType(AppFailureCard), findsNothing);
          expect(
            find.text('Selected valid certification.'),
            findsOneWidget,
          );
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

          await tester.tap(find.text('View details'));
          await tester.pump();

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.text('Threats and vulnerabilities.'), findsNothing);
          expect(
            find.text('Strengthened baseline security knowledge.'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders selector label field failures explicitly',
        (tester) async {
          final certification = buildCertification().copyWith(
            credentialDetails: buildCertification().credentialDetails.copyWith(
              issuer: SingleLineText(''),
            ),
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

          expect(
            find.byType(FieldFailureWidget),
            findsAtLeastNWidgets(2),
          );
          expect(find.text('A certification summary.'), findsOneWidget);
        },
      );

      testWidgets(
        'renders failure entries in the selector '
        'and shows details when selected',
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

          expect(find.text('Security+'), findsNWidgets(2));
          expect(find.text('Unavailable certification'), findsOneWidget);
          expect(find.byType(AppFailureCard), findsNothing);

          await tester.tap(
            find.byKey(const ValueKey<String>('entry-selector-item-1')),
          );
          await tester.pumpAndSettle();

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

String _buildLongText() => List<String>.filled(
  60,
  'This certification summary is intentionally long for disclosure testing.',
).join(' ');
