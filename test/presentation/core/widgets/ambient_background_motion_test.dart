import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/ambient_background_motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'AmbientBackgroundMotion',
    () {
      testWidgets(
        'settles decorative content over time when motion is enabled',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: AmbientBackgroundMotion(
                  child: ColoredBox(
                    color: Colors.amber,
                    child: SizedBox.expand(),
                  ),
                ),
              ),
            ),
          );

          final initialOpacity = tester.widget<Opacity>(
            find.descendant(
              of: find.byType(AmbientBackgroundMotion),
              matching: find.byType(Opacity),
            ),
          );

          expect(initialOpacity.opacity, 0.985);

          await tester.pump();
          await tester.pump(AppMotion.durationSlow);

          final settledOpacity = tester.widget<Opacity>(
            find.descendant(
              of: find.byType(AmbientBackgroundMotion),
              matching: find.byType(Opacity),
            ),
          );

          expect(settledOpacity.opacity, 1);
        },
      );

      testWidgets(
        'renders immediately when reduced motion is requested',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: MediaQuery(
                data: MediaQueryData(disableAnimations: true),
                child: Scaffold(
                  body: AmbientBackgroundMotion(
                    child: Text('Ambient layer'),
                  ),
                ),
              ),
            ),
          );

          expect(find.text('Ambient layer'), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(AmbientBackgroundMotion),
              matching: find.byType(Opacity),
            ),
            findsNothing,
          );
        },
      );
    },
  );
}
