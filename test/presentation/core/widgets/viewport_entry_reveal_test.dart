import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/viewport_entry_reveal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ViewportEntryReveal',
    () {
      testWidgets(
        'reveals when content becomes visible after the first frame '
        'without requiring scroll input',
        (tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: _DelayedVisibilityHost(
                    child: ViewportEntryReveal(
                      child: Text('Reveal target'),
                    ),
                  ),
                ),
              ),
            ),
          );

          await tester.pump();

          expect(find.text('Reveal target'), findsOneWidget);

          await tester.pump(AppMotion.durationSlow);

          final settledOpacity = tester.widget<Opacity>(
            find.descendant(
              of: find.byType(ViewportEntryReveal),
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
                  body: ViewportEntryReveal(
                    child: Text('Reveal target'),
                  ),
                ),
              ),
            ),
          );

          expect(find.text('Reveal target'), findsOneWidget);
          expect(find.byType(Opacity), findsNothing);
        },
      );
    },
  );
}

class _DelayedVisibilityHost extends StatefulWidget {
  const _DelayedVisibilityHost({
    required this.child,
  });

  final Widget child;

  @override
  State<_DelayedVisibilityHost> createState() => _DelayedVisibilityHostState();
}

class _DelayedVisibilityHostState extends State<_DelayedVisibilityHost> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => Offstage(
    offstage: !_isVisible,
    child: widget.child,
  );
}
