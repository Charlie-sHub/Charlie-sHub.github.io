import 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/codersrank_supporting_section_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../presentation_test_helpers.dart';

void main() {
  group(
    'CodersRankSupportingSectionContent',
    () {
      testWidgets(
        'omits the section entirely when CodersRank is unavailable',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const CodersRankSupportingSectionContent(
                isVisible: false,
              ),
            ),
          );

          expect(find.text('CodersRank'), findsNothing);
          expect(find.text('Rank widgets'), findsNothing);
          expect(find.text('GitHub profile'), findsNothing);
        },
      );

      testWidgets(
        'renders only the remaining rank panel on wider layouts',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const CodersRankSupportingSectionContent(
                isVisible: true,
                rankWidget: SizedBox(
                  key: ValueKey<String>('codersrank-rank-widget'),
                  height: 140,
                ),
              ),
            ),
          );

          expect(find.text('CodersRank'), findsOneWidget);
          expect(find.text('Rank widgets'), findsNothing);
          expect(find.text('GitHub profile'), findsNothing);
          expect(
            find.byKey(const ValueKey<String>('codersrank-rank-widget')),
            findsOneWidget,
          );
          expect(
            find.byKey(const ValueKey<String>('codersrank-github-panel')),
            findsNothing,
          );
        },
      );
    },
  );
}
