import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../presentation_test_helpers.dart';

void main() {
  group(
    'Section Text',
    () {
      testWidgets(
        'renders section titles and subtitles with warm accent styling',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeadingText(text: 'Projects'),
                  SectionSupportingText(text: 'Loading project content...'),
                ],
              ),
            ),
          );

          final heading = tester.widget<Text>(find.text('Projects'));
          final subtitle = tester.widget<Text>(
            find.text('Loading project content...'),
          );
          final context = tester.element(find.text('Projects'));
          final headlineSmall = Theme.of(context).textTheme.headlineSmall;
          final bodyMedium = Theme.of(context).textTheme.bodyMedium;

          expect(heading.style?.color, AppColors.warmAccent);
          expect(
            heading.style?.fontSize,
            greaterThan(headlineSmall?.fontSize ?? 0),
          );
          expect(subtitle.style?.color, AppColors.warmAccent);
          expect(
            subtitle.style?.fontSize,
            greaterThan(bodyMedium?.fontSize ?? 0),
          );
          expect(heading.style?.shadows, isNotEmpty);
          expect(subtitle.style?.shadows, isNotEmpty);
        },
      );
    },
  );

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

          final heading = tester.widget<Text>(find.text('Implementation'));
          final context = tester.element(find.text('Implementation'));
          final titleMedium = Theme.of(context).textTheme.titleMedium;

          expect(find.text('Implementation'), findsOneWidget);
          expect(find.text('Shared content block body'), findsOneWidget);
          expect(heading.style?.color, AppColors.warmAccent);
          expect(
            heading.style?.fontSize,
            (titleMedium?.fontSize ?? 16) * 1.2,
          );
        },
      );
    },
  );

  group(
    'ContentCard',
    () {
      testWidgets(
        'renders child content without section blur',
        (tester) async {
          await tester.pumpWidget(
            buildPresentationTestApp(
              const ContentCard(
                child: Text('Card content'),
              ),
            ),
          );

          expect(find.text('Card content'), findsOneWidget);
          expect(find.byType(BackdropFilter), findsNothing);
        },
      );
    },
  );

  group(
    'SectionContainer',
    () {
      testWidgets(
        'renders heading and child content with a section surface blur',
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
          expect(find.byType(BackdropFilter), findsOneWidget);
          expect(AppSurfaceStyles.sectionBlurSigma, 6);
          expect(
            find.descendant(
              of: find.byType(BackdropFilter),
              matching: find.text('Projects'),
            ),
            findsOneWidget,
          );
        },
      );
    },
  );
}
