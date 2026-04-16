import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_theme.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/disclosure_toggle_button.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entity_disclosure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entry_selector_panel.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/expandable_text_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/expandable_value_text_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'DisclosureToggleButton',
    () {
      testWidgets(
        'uses the cool accent as a text-only disclosure control',
        (tester) async {
          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 320,
              child: const DisclosureToggleButton(
                isExpanded: false,
                expandLabel: 'Read more',
                collapseLabel: 'Show less',
                onPressed: _noop,
              ),
            ),
          );

          final button = tester.widget<TextButton>(find.byType(TextButton));
          final foregroundColor = button.style?.foregroundColor?.resolve(
            const <WidgetState>{},
          );
          final backgroundColor = button.style?.backgroundColor?.resolve(
            const <WidgetState>{},
          );

          expect(foregroundColor, AppColors.coolAccent);
          expect(backgroundColor, Colors.transparent);
        },
      );
    },
  );

  group(
    'ExpandableTextBlock',
    () {
      testWidgets(
        'starts collapsed with preview lines and a read-more control',
        (tester) async {
          final longText = _buildLongText();

          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 220,
              child: ExpandableTextBlock(
                text: longText,
                collapsedMaxLines: 2,
              ),
            ),
          );

          final contentText = tester.widget<Text>(find.text(longText));

          expect(contentText.maxLines, 2);
          expect(contentText.overflow, TextOverflow.ellipsis);
          expect(find.text('Read more'), findsOneWidget);
          expect(find.text('Show less'), findsNothing);
          expect(find.text(longText), findsOneWidget);
        },
      );

      testWidgets(
        'expands and collapses again when the disclosure control is tapped',
        (tester) async {
          final longText = _buildLongText();

          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 220,
              child: ExpandableTextBlock(
                text: longText,
                collapsedMaxLines: 2,
              ),
            ),
          );

          await tester.tap(find.text('Read more'));
          await tester.pump();

          final expandedText = tester.widget<Text>(find.text(longText));

          expect(expandedText.maxLines, isNull);
          expect(expandedText.overflow, TextOverflow.visible);
          expect(find.text('Show less'), findsOneWidget);
          expect(find.text('Read more'), findsNothing);

          await tester.ensureVisible(find.text('Show less'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Show less'));
          await tester.pump();

          final collapsedText = tester.widget<Text>(find.text(longText));

          expect(collapsedText.maxLines, 2);
          expect(collapsedText.overflow, TextOverflow.ellipsis);
          expect(find.text('Read more'), findsOneWidget);
          expect(find.text('Show less'), findsNothing);
        },
      );

      testWidgets(
        'hides the disclosure control when the text already fits',
        (tester) async {
          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 320,
              child: const ExpandableTextBlock(
                text: 'Short supporting copy.',
                collapsedMaxLines: 2,
              ),
            ),
          );

          final contentText = tester.widget<Text>(
            find.text('Short supporting copy.'),
          );

          expect(contentText.maxLines, 2);
          expect(find.text('Read more'), findsNothing);
          expect(find.text('Show less'), findsNothing);
        },
      );
    },
  );

  group(
    'EntityDisclosureCard',
    () {
      testWidgets(
        'starts collapsed and reveals details when expanded',
        (tester) async {
          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 480,
              child: const EntityDisclosureCard(
                preview: Text('Preview content'),
                details: Text('Detailed content'),
              ),
            ),
          );

          expect(find.text('Preview content'), findsOneWidget);
          expect(find.text('Detailed content'), findsNothing);
          expect(find.text('View details'), findsOneWidget);

          await tester.tap(find.text('View details'));
          await tester.pump();

          expect(find.text('Detailed content'), findsOneWidget);
          expect(find.text('Hide details'), findsOneWidget);
          expect(find.text('View details'), findsNothing);
        },
      );

      testWidgets(
        'renders expanded content immediately when initiallyExpanded is true',
        (tester) async {
          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 480,
              child: const EntityDisclosureCard(
                preview: Text('Preview content'),
                details: Text('Detailed content'),
                initiallyExpanded: true,
              ),
            ),
          );

          expect(find.text('Preview content'), findsOneWidget);
          expect(find.text('Detailed content'), findsOneWidget);
          expect(find.text('Hide details'), findsOneWidget);
        },
      );
    },
  );

  group(
    'ExpandableValueTextBlock',
    () {
      testWidgets(
        'renders expandable validated content for a valid long-form field',
        (tester) async {
          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 220,
              child: ExpandableValueTextBlock(
                field: NonEmptyText(_buildLongText()),
                collapsedMaxLines: 2,
              ),
            ),
          );

          expect(find.text('Read more'), findsOneWidget);
          expect(find.byType(FieldFailureWidget), findsNothing);

          await tester.tap(find.text('Read more'));
          await tester.pump();

          expect(find.text('Show less'), findsOneWidget);
        },
      );

      testWidgets(
        'renders a failure widget when the field is invalid',
        (tester) async {
          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 320,
              child: ExpandableValueTextBlock(
                field: NonEmptyText(''),
              ),
            ),
          );

          expect(find.byType(FieldFailureWidget), findsOneWidget);
          expect(find.text('Read more'), findsNothing);
          expect(find.text('Show less'), findsNothing);
        },
      );
    },
  );

  group(
    'EntrySelectorPanel',
    () {
      testWidgets(
        'renders selector entries and the initial selected content',
        (tester) async {
          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 960,
              child: _buildSelectorPanel(),
            ),
          );

          expect(find.text('Alpha'), findsOneWidget);
          expect(find.text('Beta'), findsOneWidget);
          expect(find.text('Detail Alpha'), findsOneWidget);
          expect(find.text('Detail Beta'), findsNothing);
        },
      );

      testWidgets(
        'places the selector to the left of the detail pane in wide layouts',
        (tester) async {
          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 960,
              child: _buildSelectorPanel(),
            ),
          );

          final selectorRect = tester.getRect(
            find.byKey(
              const ValueKey<String>('entry-selector-panel-selector-pane'),
            ),
          );
          final detailRect = tester.getRect(
            find.byKey(
              const ValueKey<String>('entry-selector-panel-detail-pane'),
            ),
          );

          expect(selectorRect.left, lessThan(detailRect.left));
        },
      );

      testWidgets(
        'stacks the selector above the detail pane in compact layouts',
        (tester) async {
          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 480,
              child: _buildSelectorPanel(),
            ),
          );

          final selectorRect = tester.getRect(
            find.byKey(
              const ValueKey<String>('entry-selector-panel-selector-pane'),
            ),
          );
          final detailRect = tester.getRect(
            find.byKey(
              const ValueKey<String>('entry-selector-panel-detail-pane'),
            ),
          );

          expect(selectorRect.top, lessThan(detailRect.top));
        },
      );

      testWidgets(
        'updates the detail pane when a different entry is selected',
        (tester) async {
          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 960,
              child: _buildSelectorPanel(),
            ),
          );

          expect(find.text('Detail Alpha'), findsOneWidget);
          expect(find.text('Detail Beta'), findsNothing);

          await tester.tap(
            find.byKey(const ValueKey<String>('entry-selector-item-1')),
          );
          await tester.pump();

          expect(find.text('Detail Alpha'), findsNothing);
          expect(find.text('Detail Beta'), findsOneWidget);
        },
      );

      testWidgets(
        'handles an empty entry list gracefully',
        (tester) async {
          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 960,
              child: EntrySelectorPanel<String>(
                entries: const [],
                labelBuilder: (context, entry, {required isSelected}) =>
                    Text(entry),
                detailBuilder: (context, entry) => Text('Detail $entry'),
              ),
            ),
          );

          expect(find.byType(ContentCard), findsNothing);
          expect(
            find.byKey(
              const ValueKey<String>('entry-selector-panel-detail-pane'),
            ),
            findsNothing,
          );
        },
      );

      testWidgets(
        'handles a single entry without requiring reselection',
        (tester) async {
          await tester.pumpWidget(
            _buildSizedTestApp(
              width: 960,
              child: EntrySelectorPanel<String>(
                entries: const ['Solo'],
                labelBuilder: (context, entry, {required isSelected}) =>
                    Text(entry),
                detailBuilder: (context, entry) => Text('Detail $entry'),
              ),
            ),
          );

          expect(find.text('Solo'), findsOneWidget);
          expect(find.text('Detail Solo'), findsOneWidget);
          expect(find.text('Detail Alpha'), findsNothing);
        },
      );
    },
  );
}

Widget _buildSizedTestApp({
  required double width,
  required Widget child,
}) => MaterialApp(
  theme: buildAppTheme(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: width,
          child: child,
        ),
      ),
    ),
  ),
);

Widget _buildSelectorPanel() => EntrySelectorPanel<String>(
  entries: const ['Alpha', 'Beta'],
  labelBuilder: (context, entry, {required isSelected}) => Text(entry),
  detailBuilder: (context, entry) => Text('Detail $entry'),
);

String _buildLongText() => List<String>.filled(
  40,
  'This is intentionally long body copy.',
).join(' ');

void _noop() {}
