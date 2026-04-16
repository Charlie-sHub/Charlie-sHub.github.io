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
          expect(find.text('GitHub activity matrix'), findsNothing);
        },
      );

      testWidgets(
        'renders the supporting panels in a column on wider layouts',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const CodersRankSupportingSectionContent(
                isVisible: true,
                rankWidget: SizedBox(
                  key: ValueKey<String>('codersrank-rank-widget'),
                  height: 140,
                ),
                activityWidget: SizedBox(
                  key: ValueKey<String>('codersrank-activity-widget'),
                  height: 180,
                ),
              ),
            ),
          );

          expect(find.text('CodersRank'), findsOneWidget);
          expect(find.text('Rank widgets'), findsOneWidget);
          expect(find.text('GitHub activity matrix'), findsOneWidget);
          expect(
            find.byKey(const ValueKey<String>('codersrank-rank-widget')),
            findsOneWidget,
          );
          expect(
            find.byKey(const ValueKey<String>('codersrank-activity-widget')),
            findsOneWidget,
          );

          final rankRect = tester.getRect(
            find.byKey(const ValueKey<String>('codersrank-rank-panel')),
          );
          final activityRect = tester.getRect(
            find.byKey(const ValueKey<String>('codersrank-activity-panel')),
          );

          expect(activityRect.top, greaterThan(rankRect.bottom));
        },
      );

      testWidgets(
        'keeps the rank panel above the activity panel on narrower layouts',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const CodersRankSupportingSectionContent(
                isVisible: true,
                rankWidget: SizedBox(
                  key: ValueKey<String>('codersrank-rank-widget'),
                  height: 140,
                ),
                activityWidget: SizedBox(
                  key: ValueKey<String>('codersrank-activity-widget'),
                  height: 180,
                ),
              ),
              width: 720,
            ),
          );

          final rankRect = tester.getRect(
            find.byKey(const ValueKey<String>('codersrank-rank-panel')),
          );
          final activityRect = tester.getRect(
            find.byKey(const ValueKey<String>('codersrank-activity-panel')),
          );

          expect(activityRect.top, greaterThan(rankRect.bottom));
        },
      );
    },
  );
}
