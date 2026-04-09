import 'package:charlie_shub_portfolio/presentation/widgets/core/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../presentation_test_helpers.dart';

void main() {
  group(
    'ContentBlock',
    () {
      testWidgets(
        'renders a heading and child content',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const ContentBlock(
                title: 'Implementation',
                child: Text('Shared content block body'),
              ),
            ),
          );

          expect(find.text('Implementation'), findsOneWidget);
          expect(find.text('Shared content block body'), findsOneWidget);
        },
      );
    },
  );

  group(
    'ContentCard',
    () {
      testWidgets(
        'renders child content',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const ContentCard(
                child: Text('Card content'),
              ),
            ),
          );

          expect(find.text('Card content'), findsOneWidget);
        },
      );
    },
  );

  group(
    'SectionContainer',
    () {
      testWidgets(
        'renders heading and child content',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const SectionContainer(
                heading: SectionHeadingText(text: 'Projects'),
                children: [
                  Text('Section body'),
                ],
              ),
            ),
          );

          expect(find.text('Projects'), findsOneWidget);
          expect(find.text('Section body'), findsOneWidget);
        },
      );
    },
  );
}
