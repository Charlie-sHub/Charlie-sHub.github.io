import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/link_reference_kind.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_button_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/contact/link_button.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/contact/link_button_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/contact/validated_link_button.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/labeled_tag_group_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_frame.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_tile.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/tag_chip_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_asset_media_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart'
    show
        Column,
        CrossAxisAlignment,
        EdgeInsets,
        Icon,
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
    'LinkButton',
    () {
      testWidgets(
        'renders a shared link button and triggers the tap callback',
        (tester) async {
          var tapped = false;

          await tester.pumpWidget(
            buildPresentationTestApp(
              LinkButton(
                label: 'Email',
                url: 'mailto:carlosrafael-mg@hotmail.com',
                icon: Icons.mail_outline_rounded,
                onTap: () => tapped = true,
              ),
            ),
          );

          await tester.tap(find.text('Email'));
          await tester.pump();

          expect(find.text('Email'), findsOneWidget);
          expect(find.text('Open link'), findsNothing);
          expect(tapped, isTrue);
        },
      );

      testWidgets(
        'renders a validated link button and triggers the tap callback',
        (tester) async {
          var tapped = false;

          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedLinkButton(
                linkReference: LinkReference(
                  label: SingleLineText('Repository'),
                  url: UrlValue('https://example.com/project'),
                  kind: LinkReferenceKind.repository,
                ),
                onTap: () => tapped = true,
              ),
            ),
          );

          await tester.tap(find.text('Repository'));
          await tester.pump();

          expect(find.text('Repository'), findsOneWidget);
          expect(find.text('https://example.com/project'), findsNothing);
          expect(tapped, isTrue);
        },
      );

      testWidgets(
        'uses explicit link semantics instead of inferring the icon',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedLinkButton(
                linkReference: LinkReference(
                  label: SingleLineText('Profile'),
                  url: UrlValue('https://example.com/profile'),
                  kind: LinkReferenceKind.linkedin,
                ),
              ),
            ),
          );

          expect(find.byIcon(Icons.badge_outlined), findsOneWidget);
          expect(find.byIcon(Icons.link_rounded), findsNothing);
        },
      );

      testWidgets(
        'falls back to the neutral external-link icon when no kind is set',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedLinkButton(
                linkReference: LinkReference(
                  label: SingleLineText('Profile'),
                  url: UrlValue('https://example.com/profile'),
                ),
              ),
            ),
          );

          expect(find.byIcon(Icons.link_rounded), findsOneWidget);
          expect(find.byIcon(Icons.badge_outlined), findsNothing);
        },
      );

      testWidgets(
        'renders the canonical link button as a label-only warm button',
        (tester) async {
          var tapped = false;

          await tester.pumpWidget(
            buildPresentationTestApp(
              LinkButton(
                label: 'GitHub',
                url: 'https://example.com/github',
                icon: Icons.code_rounded,
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
        'uses the shared warm accent styling',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const LinkButton(
                label: 'Credential proof',
                url: 'https://example.com/certification',
                icon: Icons.verified_outlined,
              ),
            ),
          );

          final icon = tester.widget<Icon>(
            find.byIcon(Icons.verified_outlined),
          );

          expect(icon.color, isNull);
        },
      );

      testWidgets(
        'uses distinct compact, standard, and large link-button sizing',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinkButton(
                    label: 'Sticky',
                    url: 'https://example.com/sticky',
                    icon: Icons.link_rounded,
                    size: LinkButtonSize.compact,
                  ),
                  SizedBox(height: 12),
                  LinkButton(
                    label: 'Reference',
                    url: 'https://example.com/reference',
                    icon: Icons.link_rounded,
                  ),
                  SizedBox(height: 12),
                  LinkButton(
                    label: 'Resume',
                    url: 'https://example.com/resume',
                    icon: Icons.description_outlined,
                    size: LinkButtonSize.large,
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
          final standardPadding = buttons[1].style?.padding?.resolve(
            const <WidgetState>{},
          );
          final largePadding = buttons.last.style?.padding?.resolve(
            const <WidgetState>{},
          );
          final compactTextStyle = buttons.first.style?.textStyle?.resolve(
            const <WidgetState>{},
          );
          final standardTextStyle = buttons[1].style?.textStyle?.resolve(
            const <WidgetState>{},
          );
          final largeTextStyle = buttons.last.style?.textStyle?.resolve(
            const <WidgetState>{},
          );
          final compactBackground = buttons.first.style?.backgroundColor
              ?.resolve(const <WidgetState>{});
          final standardBackground = buttons[1].style?.backgroundColor?.resolve(
            const <WidgetState>{},
          );
          final largeBackground = buttons.last.style?.backgroundColor?.resolve(
            const <WidgetState>{},
          );

          expect(
            compactPadding,
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.size16,
              vertical: AppSpacing.size12,
            ),
          );
          expect(
            standardPadding,
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.size16,
              vertical: AppSpacing.size12,
            ),
          );
          expect(
            largePadding,
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.size20,
              vertical: AppSpacing.size16,
            ),
          );
          expect(
            standardTextStyle?.fontSize,
            greaterThan(compactTextStyle?.fontSize ?? 0),
          );
          expect(
            largeTextStyle?.fontSize,
            greaterThanOrEqualTo(standardTextStyle?.fontSize ?? 0),
          );
          expect(compactBackground, AppColors.warmAccent);
          expect(standardBackground, AppColors.warmAccent);
          expect(largeBackground, AppColors.warmAccent);
        },
      );

      testWidgets(
        'uses full-width button content with a consistent icon slot and gap',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const SizedBox(
                width: 240,
                child: LinkButton(
                  label: 'GitHub',
                  url: 'https://example.com/github',
                  icon: Icons.code_rounded,
                ),
              ),
            ),
          );

          final buttonRect = tester.getRect(find.byType(TextButton));
          final iconRect = tester.getRect(find.byIcon(Icons.code_rounded));
          final labelRect = tester.getRect(find.text('GitHub'));

          expect(labelRect.left - iconRect.right, AppSpacing.size8);
          expect(iconRect.width, AppLayout.actionLeadingIconSize);
          expect(iconRect.left, greaterThan(buttonRect.left));
          expect(labelRect.right, lessThan(buttonRect.right));
        },
      );

      testWidgets(
        'renders a failure widget when the validated label is invalid',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              ValidatedLinkButton(
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
          expect(
            tester.getSize(find.byType(PdfPreviewFrame)).height,
            AppLayout.pdfPreviewHeight,
          );

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
    'LinkButtonList',
    () {
      testWidgets(
        'renders multiple links and triggers callbacks for each item',
        (tester) async {
          final tappedLabels = <String>[];

          await tester.pumpWidget(
            buildPresentationTestApp(
              LinkButtonList(
                links: [
                  LinkReference(
                    label: SingleLineText('Repository'),
                    url: UrlValue('https://example.com/project'),
                    kind: LinkReferenceKind.repository,
                  ),
                  LinkReference(
                    label: SingleLineText('Documentation'),
                    url: UrlValue('https://example.com/docs'),
                    kind: LinkReferenceKind.documentation,
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
        'uses the shared family accent by default for link buttons',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              LinkButtonList(
                links: [
                  LinkReference(
                    label: SingleLineText('Repository'),
                    url: UrlValue('https://example.com/project'),
                    kind: LinkReferenceKind.repository,
                  ),
                ],
              ),
            ),
          );

          final leadingIcon = tester.widget<Icon>(
            find.byIcon(Icons.source_outlined),
          );

          expect(leadingIcon.color, isNull);
        },
      );

      testWidgets(
        'handles an empty list gracefully',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const LinkButtonList(links: []),
            ),
          );

          expect(find.byType(ValidatedLinkButton), findsNothing);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders a collection failure instead of links',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const LinkButtonList(
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
          expect(find.byType(ValidatedLinkButton), findsNothing);
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
