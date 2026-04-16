import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_tile.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/labeled_tag_group_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/media_placeholder.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_tile.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/tag_chip_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_asset_media_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_placeholder.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart'
    show
        Column,
        CrossAxisAlignment,
        EdgeInsets,
        Icons,
        SizedBox,
        TextButton,
        WidgetState;
import 'package:flutter_test/flutter_test.dart';

import '../presentation_test_helpers.dart';

void main() {
  group(
    'ValidatedText',
    () {
      testWidgets(
        'renders value when valid',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedText(
                field: Title('Expected value'),
              ),
            ),
          );

          expect(find.text('Expected value'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders failure widget when invalid',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedText(
                field: Title(''),
              ),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.text('Expected value'), findsNothing);
        },
      );
    },
  );

  group(
    'ValidatedAssetMediaCard',
    () {
      testWidgets(
        'renders an asset media card when path is valid',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedAssetMediaCard(
                path: AssetPath(
                  'assets/media/content/projects/world_on/world_on_login.png',
                ),
                labelBuilder: _heroLabelBuilder,
              ),
            ),
          );

          expect(find.byType(AssetMediaCard), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders a failure widget when the media path is invalid',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedAssetMediaCard(
                path: AssetPath('invalid/path.png'),
                labelBuilder: _heroLabelBuilder,
              ),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.byType(AssetMediaCard), findsNothing);
        },
      );
    },
  );

  group(
    'ValidatedPlaceholder',
    () {
      testWidgets(
        'renders media placeholder when path is valid',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedPlaceholder(
                path: AssetPath(
                  'assets/media/content/projects/pami/hero.png',
                ),
                labelBuilder: _heroLabelBuilder,
              ),
            ),
          );

          expect(find.byType(MediaPlaceholder), findsOneWidget);
          expect(find.textContaining('hero.png'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders failure widget when path is invalid',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedPlaceholder(
                path: AssetPath('invalid/path.png'),
                labelBuilder: _heroLabelBuilder,
              ),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.byType(MediaPlaceholder), findsNothing);
        },
      );
    },
  );

  group(
    'TagChipList',
    () {
      testWidgets(
        'renders all tags',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              TagChipList(
                tags: [
                  SingleLineText('Flutter'),
                  SingleLineText('Firebase'),
                ],
              ),
            ),
          );

          expect(find.text('Flutter'), findsOneWidget);
          expect(find.text('Firebase'), findsOneWidget);
        },
      );

      testWidgets(
        'renders no chips for an empty list',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const TagChipList(tags: []),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsNothing);
          expect(find.text('Flutter'), findsNothing);
        },
      );

      testWidgets(
        'renders failure widgets for invalid tags while preserving valid ones',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              TagChipList(
                tags: [
                  SingleLineText('Flutter'),
                  SingleLineText(''),
                ],
              ),
            ),
          );

          expect(find.text('Flutter'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsOneWidget);
        },
      );

      testWidgets(
        'renders a collection failure instead of tags '
        'when collection is invalid',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const TagChipList(
                tags: [],
                collectionFailure:
                    ValueFailure<List<String>>.collectionTooShort(
                      failedValue: <String>[],
                      minLength: 1,
                    ),
              ),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.text('Flutter'), findsNothing);
        },
      );
    },
  );

  group(
    'ValidatedBulletList',
    () {
      testWidgets(
        'renders all validated items',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedBulletList(
                items: [
                  NonEmptyText('Structured delivery'),
                  NonEmptyText('Security-aware implementation'),
                ],
              ),
            ),
          );

          expect(find.text('Structured delivery'), findsOneWidget);
          expect(
            find.text('Security-aware implementation'),
            findsOneWidget,
          );
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders failure widgets for invalid entries while keeping valid items',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedBulletList(
                items: [
                  NonEmptyText('Structured delivery'),
                  NonEmptyText(''),
                ],
              ),
            ),
          );

          expect(find.text('Structured delivery'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsOneWidget);
        },
      );

      testWidgets(
        'handles an empty list gracefully',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const ValidatedBulletList(items: []),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsNothing);
          expect(find.text('Structured delivery'), findsNothing);
        },
      );

      testWidgets(
        'renders a collection failure instead of list items',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const ValidatedBulletList(
                items: [],
                collectionFailure:
                    ValueFailure<List<String>>.collectionTooShort(
                      failedValue: <String>[],
                      minLength: 1,
                    ),
              ),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.text('Structured delivery'), findsNothing);
        },
      );
    },
  );

  group(
    'ExternalLinkTile',
    () {
      testWidgets(
        'renders a generic action link tile with subtitle text',
        (tester) async {
          var tapped = false;

          await tester.pumpWidget(
            buildPresentationTestApp(
              ActionLinkTile(
                label: 'Email',
                subtitle: 'carlosrafael-mg@hotmail.com',
                url: 'mailto:carlosrafael-mg@hotmail.com',
                actionLabel: 'Write',
                onTap: () => tapped = true,
              ),
            ),
          );

          await tester.tap(find.text('Email'));
          await tester.pump();

          expect(find.text('Email'), findsOneWidget);
          expect(find.text('carlosrafael-mg@hotmail.com'), findsOneWidget);
          expect(find.text('Write'), findsOneWidget);
          expect(tapped, isTrue);
        },
      );

      testWidgets(
        'renders label and triggers onTap callback',
        (tester) async {
          var tapped = false;

          await tester.pumpWidget(
            buildPresentationTestApp(
              ExternalLinkTile(
                linkReference: LinkReference(
                  label: SingleLineText('Repository'),
                  url: UrlValue('https://example.com/project'),
                ),
                onTap: () => tapped = true,
              ),
            ),
          );

          await tester.tap(find.text('Repository'));
          await tester.pump();

          expect(find.text('Repository'), findsOneWidget);
          expect(find.text('Open link'), findsOneWidget);
          expect(find.byIcon(Icons.open_in_new), findsOneWidget);
          expect(find.text('https://example.com/project'), findsNothing);
          expect(tapped, isTrue);
        },
      );

      testWidgets(
        'renders the contact-button variant as a label-only warm button',
        (tester) async {
          var tapped = false;

          await tester.pumpWidget(
            buildPresentationTestApp(
              ActionLinkTile(
                label: 'GitHub',
                url: 'https://example.com/github',
                variant: ActionLinkVariant.contactButton,
                onTap: () => tapped = true,
              ),
            ),
          );

          await tester.tap(find.text('GitHub'));
          await tester.pump();

          final button = tester.widget<TextButton>(find.byType(TextButton));
          final defaultBackground = button.style?.backgroundColor?.resolve(
            const <WidgetState>{},
          );
          final hoverBackground = button.style?.backgroundColor?.resolve(
            const <WidgetState>{WidgetState.hovered},
          );

          expect(find.text('GitHub'), findsOneWidget);
          expect(find.text('Open link'), findsNothing);
          expect(find.byIcon(Icons.open_in_new), findsNothing);
          expect(defaultBackground, AppColors.warmAccent);
          expect(hoverBackground, AppColors.warmAccentSoft);
          expect(tapped, isTrue);
        },
      );

      testWidgets(
        'renders the large contact-button variant with larger padding',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ActionLinkTile(
                    label: 'Sticky',
                    url: 'https://example.com/sticky',
                    variant: ActionLinkVariant.contactButton,
                  ),
                  SizedBox(height: 12),
                  ActionLinkTile(
                    label: 'Resume',
                    url: 'https://example.com/resume',
                    variant: ActionLinkVariant.contactButtonLarge,
                  ),
                ],
              ),
            ),
          );

          final buttons = tester
              .widgetList<TextButton>(
                find.byType(TextButton),
              )
              .toList();
          final compactPadding = buttons.first.style?.padding?.resolve(
            const <WidgetState>{},
          );
          final largePadding = buttons.last.style?.padding?.resolve(
            const <WidgetState>{},
          );
          final compactTextStyle = buttons.first.style?.textStyle?.resolve(
            const <WidgetState>{},
          );
          final largeTextStyle = buttons.last.style?.textStyle?.resolve(
            const <WidgetState>{},
          );

          expect(
            compactPadding,
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.size16,
              vertical: AppSpacing.size10,
            ),
          );
          expect(
            largePadding,
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.size20,
              vertical: AppSpacing.size14,
            ),
          );
          expect(
            largeTextStyle?.fontSize,
            greaterThan(compactTextStyle?.fontSize ?? 0),
          );
        },
      );

      testWidgets(
        'shows the URL when explicitly requested',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ExternalLinkTile(
                linkReference: LinkReference(
                  label: SingleLineText('Repository'),
                  url: UrlValue('https://example.com/project'),
                ),
                showUrl: true,
              ),
            ),
          );

          expect(find.text('Repository'), findsOneWidget);
          expect(find.text('https://example.com/project'), findsOneWidget);
        },
      );

      testWidgets(
        'renders a failure widget when the label is invalid',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ExternalLinkTile(
                linkReference: LinkReference(
                  label: SingleLineText(''),
                  url: UrlValue('https://example.com/project'),
                ),
              ),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.text('Repository'), findsNothing);
        },
      );
    },
  );

  group(
    'ValidatedPdfPreviewTile',
    () {
      testWidgets(
        'renders a PDF preview tile and triggers the tap callback',
        (tester) async {
          var tapped = false;

          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedPdfPreviewTile(
                path: DocumentPath('assets/documents/resume/resume.pdf'),
                title: 'Resume PDF',
                onTap: () => tapped = true,
              ),
            ),
          );

          expect(find.byType(PdfPreviewTile), findsOneWidget);
          expect(find.text('Resume PDF'), findsOneWidget);
          expect(find.text('resume.pdf'), findsOneWidget);
          expect(find.text('Open PDF'), findsOneWidget);
          expect(find.text('PDF preview'), findsOneWidget);
          expect(find.byIcon(Icons.open_in_new), findsOneWidget);

          await tester.tap(find.text('Resume PDF'));
          await tester.pump();

          expect(tapped, isTrue);
        },
      );

      testWidgets(
        'renders a failure widget when the document path is invalid',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedPdfPreviewTile(
                path: DocumentPath('invalid/document.pdf'),
                title: 'Resume PDF',
              ),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.byType(PdfPreviewTile), findsNothing);
        },
      );
    },
  );

  group(
    'ExternalLinkList',
    () {
      testWidgets(
        'renders multiple links and triggers callbacks for each item',
        (tester) async {
          final tappedLabels = <String>[];

          await tester.pumpWidget(
            buildPresentationTestApp(
              ExternalLinkList(
                links: [
                  LinkReference(
                    label: SingleLineText('Repository'),
                    url: UrlValue('https://example.com/project'),
                  ),
                  LinkReference(
                    label: SingleLineText('Documentation'),
                    url: UrlValue('https://example.com/docs'),
                  ),
                ],
                onLinkTap: (link) {
                  final label = link.label.getOrCrash();
                  tappedLabels.add(label);
                },
              ),
            ),
          );

          await tester.tap(find.text('Repository'));
          await tester.pump();
          await tester.tap(find.text('Documentation'));
          await tester.pump();

          expect(find.text('Repository'), findsOneWidget);
          expect(find.text('Documentation'), findsOneWidget);
          expect(tappedLabels, ['Repository', 'Documentation']);
        },
      );

      testWidgets(
        'handles an empty list gracefully',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const ExternalLinkList(links: []),
            ),
          );

          expect(find.byType(ExternalLinkTile), findsNothing);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders a collection failure instead of links',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const ExternalLinkList(
                links: [],
                collectionFailure:
                    ValueFailure<List<String>>.collectionTooShort(
                      failedValue: <String>[],
                      minLength: 1,
                    ),
              ),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.byType(ExternalLinkTile), findsNothing);
        },
      );
    },
  );

  group(
    'MetadataRow',
    () {
      testWidgets(
        'renders all provided metadata entries',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              MetadataRow(
                items: [
                  MetadataItemData(
                    label: 'Issuer',
                    value: SingleLineText('CompTIA'),
                  ),
                  MetadataItemData(
                    label: 'Level',
                    value: SingleLineText('Associate'),
                  ),
                ],
              ),
            ),
          );

          expect(find.text('Issuer'), findsOneWidget);
          expect(find.text('CompTIA'), findsOneWidget);
          expect(find.text('Level'), findsOneWidget);
          expect(find.text('Associate'), findsOneWidget);
        },
      );

      testWidgets(
        'handles empty metadata gracefully',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const MetadataRow(items: []),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsNothing);
          expect(find.text('Issuer'), findsNothing);
        },
      );

      testWidgets(
        'renders failure widgets for invalid values',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              MetadataRow(
                items: [
                  MetadataItemData(
                    label: 'Issuer',
                    value: SingleLineText(''),
                  ),
                ],
              ),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
        },
      );
    },
  );

  group(
    'LabeledTagGroupCard',
    () {
      testWidgets(
        'renders the label and tags for valid content',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              LabeledTagGroupCard(
                label: SingleLineText('Engineering'),
                items: [
                  SingleLineText('Flutter'),
                  SingleLineText('Dart'),
                ],
              ),
            ),
          );

          expect(find.text('Engineering'), findsOneWidget);
          expect(find.text('Flutter'), findsOneWidget);
          expect(find.text('Dart'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders label failures while preserving valid tags',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              LabeledTagGroupCard(
                label: SingleLineText(''),
                items: [
                  SingleLineText('Flutter'),
                ],
              ),
            ),
          );

          expect(find.text('Flutter'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsOneWidget);
        },
      );

      testWidgets(
        'renders collection failures for invalid tag groups',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              LabeledTagGroupCard(
                label: SingleLineText('Engineering'),
                items: const [],
                collectionFailure:
                    const ValueFailure<List<String>>.collectionTooShort(
                      failedValue: <String>[],
                      minLength: 1,
                    ),
              ),
            ),
          );

          expect(find.text('Engineering'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.text('Flutter'), findsNothing);
        },
      );
    },
  );
}

String _heroLabelBuilder(String value) => 'Project media available: $value';
