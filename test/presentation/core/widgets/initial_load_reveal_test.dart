import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/initial_load_reveal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'InitialLoadReveal',
    () {
      testWidgets(
        'reveals content over time when motion is enabled',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: InitialLoadReveal(
                  child: Text('Portfolio'),
                ),
              ),
            ),
          );

          final initialOpacity = tester.widget<Opacity>(
            find.descendant(
              of: find.byType(InitialLoadReveal),
              matching: find.byType(Opacity),
            ),
          );

          expect(initialOpacity.opacity, 0);
          expect(find.text('Portfolio'), findsOneWidget);

          await tester.pump();
          await tester.pump(AppMotion.durationStandard);

          final settledOpacity = tester.widget<Opacity>(
            find.descendant(
              of: find.byType(InitialLoadReveal),
              matching: find.byType(Opacity),
            ),
          );

          expect(settledOpacity.opacity, 1);
        },
      );

      testWidgets(
        'renders content immediately when reduced motion is requested',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: MediaQuery(
                data: MediaQueryData(disableAnimations: true),
                child: Scaffold(
                  body: InitialLoadReveal(
                    child: Text('Portfolio'),
                  ),
                ),
              ),
            ),
          );

          expect(find.text('Portfolio'), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(InitialLoadReveal),
              matching: find.byType(Opacity),
            ),
            findsNothing,
          );
        },
      );
    },
  );
}
