import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'buildAppTheme',
    () {
      test(
        'uses Geometria as the primary app font family',
        () {
          final theme = buildAppTheme();

          expect(theme.textTheme.titleLarge?.fontFamily, 'Geometria');
          expect(theme.textTheme.bodyLarge?.fontFamily, 'Geometria');
        },
      );

      testWidgets(
        'uses MovingSkate only for the author-name accent role',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              theme: buildAppTheme(),
              home: Builder(
                builder: (context) => Text(
                  'Carlos Mendez',
                  style: AppTextStyles.authorName(context),
                ),
              ),
            ),
          );

          final text = tester.widget<Text>(find.text('Carlos Mendez'));

          expect(text.style?.fontFamily, 'MovingSkate');
          expect(text.style?.fontFamilyFallback, contains('Geometria'));
        },
      );
    },
  );
}
