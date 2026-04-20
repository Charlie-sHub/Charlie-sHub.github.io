import 'package:charlie_shub_portfolio/presentation/core/theme/app_motion.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'AppMotionContext',
    () {
      testWidgets(
        'preserves shared motion values when reduced motion is not requested',
        (tester) async {
          late bool prefersReducedMotion;
          late Duration duration;
          late Curve curve;
          late double distance;
          late Offset offset;

          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Builder(
                  builder: (context) {
                    prefersReducedMotion = context.prefersReducedMotion;
                    duration = context.resolveMotionDuration(
                      AppMotion.durationStandard,
                    );
                    curve = context.resolveMotionCurve(AppMotion.curveSmooth);
                    distance = context.resolveMotionDistance(
                      AppMotion.distanceStandard,
                    );
                    offset = context.resolveMotionOffset(
                      const Offset(0, AppMotion.distanceSmall),
                    );

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          );

          expect(prefersReducedMotion, isFalse);
          expect(duration, AppMotion.durationStandard);
          expect(curve, AppMotion.curveSmooth);
          expect(distance, AppMotion.distanceStandard);
          expect(offset, const Offset(0, AppMotion.distanceSmall));
        },
      );

      testWidgets(
        'collapses motion values when animations are disabled',
        (tester) async {
          late bool prefersReducedMotion;
          late Duration duration;
          late Curve curve;
          late double distance;
          late Offset offset;

          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Builder(
                  builder: (context) {
                    prefersReducedMotion = context.prefersReducedMotion;
                    duration = context.resolveMotionDuration(
                      AppMotion.durationStandard,
                    );
                    curve = context.resolveMotionCurve(
                      AppMotion.curveStandard,
                    );
                    distance = context.resolveMotionDistance(
                      AppMotion.distanceSmall,
                    );
                    offset = context.resolveMotionOffset(
                      const Offset(AppMotion.distanceSmall, 0),
                    );

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          );

          expect(prefersReducedMotion, isTrue);
          expect(duration, Duration.zero);
          expect(curve, Curves.linear);
          expect(distance, 0);
          expect(offset, Offset.zero);
        },
      );
    },
  );
}
