import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart'
    as content_title;
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entry_selector_panel.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/expandable_text_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_tile.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/labeled_tag_group_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/metadata_row.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_tile.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/tag_chip_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_placeholder.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Temporary developer-facing widget library view for visual inspection.
///
/// This showcase uses local fake data only and is intended to stay easy to
/// remove once theme and styling work no longer need it.
class WidgetShowcaseSection extends StatelessWidget {
  /// Creates the temporary widget showcase section.
  const WidgetShowcaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    final realisticLinks = <LinkReference>[
      LinkReference(
        label: SingleLineText('Repository'),
        url: UrlValue('https://github.com/example/portfolio'),
      ),
      LinkReference(
        label: SingleLineText('Write-up'),
        url: UrlValue('https://example.com/write-up'),
      ),
    ];
    const collectionFailure = ValueFailure<List<String>>.collectionTooShort(
      failedValue: <String>[],
      minLength: 1,
    );

    return SectionContainer(
      heading: const SectionHeadingText(
        text: 'Temporary Widget Showcase',
      ),
      children: [
        const SupportingText(
          text:
              'Developer-only visual inspection surface. Remove this section '
              'after reviewing the reusable widget bank.',
        ),
        const SizedBox(height: AppSpacing.size20),
        _ShowcaseGroup(
          title: 'Text & Content',
          children: [
            _ShowcaseWrap(
              children: [
                const _ExampleCard(
                  title: 'Text widgets',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeadingText(text: 'Section heading example'),
                      SizedBox(height: AppSpacing.size12),
                      HeadingText(text: 'Heading example'),
                      SizedBox(height: AppSpacing.size8),
                      BodyText(
                        text:
                            'Long-form body copy for projects, about content, '
                            'and case-study explanations.',
                      ),
                      SizedBox(height: AppSpacing.size8),
                      SupportingText(
                        text:
                            'Supporting copy for metadata, annotations, and '
                            'temporary developer notes.',
                      ),
                    ],
                  ),
                ),
                _ExampleCard(
                  title: 'ValidatedText',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SupportingText(text: 'Valid'),
                      const SizedBox(height: AppSpacing.size8),
                      ValidatedText(
                        field: content_title.Title('Realistic project title'),
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      const SupportingText(text: 'Invalid'),
                      const SizedBox(height: AppSpacing.size8),
                      ValidatedText(
                        field: content_title.Title(''),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.size16),
            _ExampleCard(
              title: 'Heading + long-form body pattern',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContentBlock(
                    title: 'Valid long-form block',
                    child: ValidatedText(
                      field: NonEmptyText(
                        'This mirrors the long-form content blocks used for '
                        'about narratives, project implementation notes, and '
                        'case-study analysis.',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.size16),
                  ContentBlock(
                    title: 'Invalid long-form block',
                    child: ValidatedText(
                      field: NonEmptyText(''),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.size16),
            _ShowcaseWrap(
              children: [
                const _ExampleCard(
                  title: 'ExpandableTextBlock',
                  child: ExpandableTextBlock(
                    text:
                        'This mirrors long-form supporting content that should '
                        'stay easy to scan on first pass while still allowing '
                        'deeper technical detail to stay available inside the '
                        'same entry without forcing a separate route or page.',
                    collapsedMaxLines: 3,
                  ),
                ),
                _ExampleCard(
                  title: 'EntrySelectorPanel',
                  child: EntrySelectorPanel<String>(
                    entries: const ['Certification', 'Course', 'Case study'],
                    labelBuilder: (context, entry, {required isSelected}) =>
                        Text(entry),
                    detailBuilder: (context, entry) => Text(
                      'Selected detail: $entry',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.size16),
        _ShowcaseGroup(
          title: 'Lists & Tags',
          children: [
            _ShowcaseWrap(
              children: [
                _ExampleCard(
                  title: 'TagChipList',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SupportingText(text: 'Valid'),
                      const SizedBox(height: AppSpacing.size8),
                      TagChipList(
                        tags: [
                          SingleLineText('Flutter'),
                          SingleLineText('Dart'),
                          SingleLineText('AppSec'),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      const SupportingText(text: 'Invalid item'),
                      const SizedBox(height: AppSpacing.size8),
                      TagChipList(
                        tags: [
                          SingleLineText('Flutter'),
                          SingleLineText(''),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      const SupportingText(text: 'Collection failure'),
                      const SizedBox(height: AppSpacing.size8),
                      const TagChipList(
                        tags: [],
                        collectionFailure: collectionFailure,
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      const SupportingText(text: 'Empty'),
                      const SizedBox(height: AppSpacing.size8),
                      const TagChipList(tags: []),
                    ],
                  ),
                ),
                _ExampleCard(
                  title: 'ValidatedBulletList',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SupportingText(text: 'Valid'),
                      const SizedBox(height: AppSpacing.size8),
                      ValidatedBulletList(
                        items: [
                          NonEmptyText('Structured delivery habits'),
                          NonEmptyText('Explicit validation boundaries'),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      const SupportingText(text: 'Invalid item'),
                      const SizedBox(height: AppSpacing.size8),
                      ValidatedBulletList(
                        items: [
                          NonEmptyText('Readable implementation notes'),
                          NonEmptyText(''),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      const SupportingText(text: 'Collection failure'),
                      const SizedBox(height: AppSpacing.size8),
                      const ValidatedBulletList(
                        items: [],
                        collectionFailure: collectionFailure,
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      const SupportingText(text: 'Empty'),
                      const SizedBox(height: AppSpacing.size8),
                      const ValidatedBulletList(items: []),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.size16),
            _ShowcaseWrap(
              children: [
                _ExampleCard(
                  title: 'LabeledTagGroupCard',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabeledTagGroupCard(
                        label: SingleLineText('Core engineering'),
                        items: [
                          SingleLineText('Flutter'),
                          SingleLineText('REST APIs'),
                          SingleLineText('Threat modeling'),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      LabeledTagGroupCard(
                        label: SingleLineText(''),
                        items: [
                          SingleLineText('Secure coding'),
                        ],
                      ),
                    ],
                  ),
                ),
                _ExampleCard(
                  title: 'Grouped skills pattern',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabeledTagGroupCard(
                        label: SingleLineText('Frontend'),
                        items: [
                          SingleLineText('Flutter'),
                          SingleLineText('Responsive layouts'),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.size12),
                      LabeledTagGroupCard(
                        label: SingleLineText('Security growth'),
                        items: const [],
                        collectionFailure: collectionFailure,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.size16),
        _ShowcaseGroup(
          title: 'Metadata & Links',
          children: [
            _ShowcaseWrap(
              children: [
                _ExampleCard(
                  title: 'MetadataRow',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MetadataRow(
                        items: [
                          MetadataItemData(
                            label: 'Issuer',
                            value: SingleLineText('CompTIA'),
                          ),
                          MetadataItemData(
                            label: 'Earned',
                            value: SingleLineText('2024-05'),
                          ),
                          MetadataItemData(
                            label: 'Level',
                            value: SingleLineText('Associate'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      MetadataRow(
                        items: [
                          MetadataItemData(
                            label: 'Invalid value',
                            value: SingleLineText(''),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      const MetadataRow(items: []),
                    ],
                  ),
                ),
                _ExampleCard(
                  title: 'ExternalLinkTile',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExternalLinkTile(
                        linkReference: LinkReference(
                          label: SingleLineText('Portfolio repository'),
                          url: UrlValue(
                            'https://github.com/example/portfolio',
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      ExternalLinkTile(
                        linkReference: LinkReference(
                          label: SingleLineText(''),
                          url: UrlValue(
                            'https://example.com/broken-link',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.size16),
            _ExampleCard(
              title: 'ExternalLinkList',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExternalLinkList(links: realisticLinks),
                  const SizedBox(height: AppSpacing.size16),
                  const ExternalLinkList(
                    links: [],
                    collectionFailure: collectionFailure,
                  ),
                  const SizedBox(height: AppSpacing.size16),
                  const ExternalLinkList(links: []),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.size16),
        _ShowcaseGroup(
          title: 'Media & Placeholders',
          children: [
            _ShowcaseWrap(
              children: [
                _ExampleCard(
                  title: 'ValidatedPlaceholder',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValidatedPlaceholder(
                        path: AssetPath(
                          'assets/media/content/projects/world_on/world_on_home_and_search.png',
                        ),
                        labelBuilder: _buildMediaLabel,
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      ValidatedPlaceholder(
                        path: AssetPath('invalid/path.png'),
                        labelBuilder: _buildMediaLabel,
                      ),
                    ],
                  ),
                ),
                _ExampleCard(
                  title: 'PDF preview tile',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValidatedPdfPreviewTile(
                        path: DocumentPath(
                          'assets/documents/certifications/comptia_security_plus_ce_certificate.pdf',
                        ),
                        title: 'Certificate PDF',
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      ValidatedPdfPreviewTile(
                        path: DocumentPath('invalid/document.pdf'),
                        title: 'Certificate PDF',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.size16),
        _ShowcaseGroup(
          title: 'Repeated Patterns',
          children: [
            _ShowcaseWrap(
              children: [
                _ExampleCard(
                  title: 'Credential or course card',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValidatedText(
                        field: content_title.Title(
                          'Security learning highlight',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.size8),
                      ContentBlock(
                        title: 'Structure',
                        child: ValidatedText(
                          field: NonEmptyText(
                            'Compact card composition used by certifications '
                            'and courses.',
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      MetadataRow(
                        items: [
                          MetadataItemData(
                            label: 'Provider',
                            value: SingleLineText('Google'),
                          ),
                          MetadataItemData(
                            label: 'Platform',
                            value: SingleLineText('Coursera'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      ValidatedPlaceholder(
                        path: AssetPath(
                          'assets/media/content/courses/google_networking/badge.png',
                        ),
                        labelBuilder: _buildMediaLabel,
                      ),
                      const SizedBox(height: AppSpacing.size16),
                      ExternalLinkList(links: realisticLinks),
                    ],
                  ),
                ),
                const _ExampleCard(
                  title: 'SectionContainer inside showcase',
                  child: SectionContainer(
                    heading: HeadingText(text: 'Nested section example'),
                    children: [
                      BodyText(
                        text:
                            'This shows the shared section wrapper used to '
                            'group related content without page-specific '
                            'layout code.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.size16),
        const _ShowcaseGroup(
          title: 'Failure States',
          children: [
            _ShowcaseWrap(
              children: [
                _ExampleCard(
                  title: 'FieldFailureWidget',
                  child: FieldFailureWidget(
                    failure: ValueFailure<String>.invalidUrl(
                      failedValue: 'http://example.com',
                    ),
                  ),
                ),
                _ExampleCard(
                  title: 'AppFailureCard',
                  child: AppFailureCard(
                    failure: AppFailure.contentLoadError(
                      path: 'assets/content/projects/index.json',
                      errorString: 'Malformed JSON payload',
                    ),
                    title: 'Projects section unavailable',
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.size16),
            _ExampleCard(
              title: 'Collection-level failure examples',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TagChipList(
                    tags: [],
                    collectionFailure: collectionFailure,
                  ),
                  SizedBox(height: AppSpacing.size16),
                  ValidatedBulletList(
                    items: [],
                    collectionFailure: collectionFailure,
                  ),
                  SizedBox(height: AppSpacing.size16),
                  ExternalLinkList(
                    links: [],
                    collectionFailure: collectionFailure,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _buildMediaLabel(String value) =>
      'Media available: ${value.split('/').last}';
}

class _ShowcaseGroup extends StatelessWidget {
  const _ShowcaseGroup({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ContentBlock(
    title: title,
    spacing: AppSpacing.size12,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

class _ShowcaseWrap extends StatelessWidget {
  const _ShowcaseWrap({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.size16,
    runSpacing: AppSpacing.size16,
    children: [
      for (final child in children)
        SizedBox(
          width: 420,
          child: child,
        ),
    ],
  );
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => ContentCard(
    child: ContentBlock(
      title: title,
      spacing: AppSpacing.size12,
      child: child,
    ),
  );
}
