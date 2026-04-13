import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/home_page.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_theme.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../application/content/content_test_entity_builders.dart';
import '../../../core/presentation_test_helpers.dart';

void main() {
  group(
    'PortfolioHomePage',
    () {
      testWidgets(
        'pins the profile summary to the left of the main content '
        'on wide layouts',
        (tester) async {
          await _pumpHomePage(tester, size: const Size(1440, 1200));

          final profileRect = tester.getRect(
            find.byKey(const ValueKey<String>('home-profile-summary')),
          );
          final introRect = tester.getRect(find.text('Portfolio Overview'));

          expect(find.text('Carlos Mendez'), findsAtLeastNWidgets(1));
          expect(profileRect.left, lessThan(introRect.left));
        },
      );

      testWidgets(
        'stacks the profile summary above the main content '
        'on compact layouts',
        (tester) async {
          await _pumpHomePage(tester, size: const Size(800, 1200));

          final profileRect = tester.getRect(
            find.byKey(const ValueKey<String>('home-profile-summary')),
          );
          final introRect = tester.getRect(find.text('Portfolio Overview'));

          expect(find.text('Carlos Mendez'), findsAtLeastNWidgets(1));
          expect(profileRect.top, lessThan(introRect.top));
        },
      );

      testWidgets(
        'keeps the temporary showcase clearly labeled as verification-only',
        (tester) async {
          await _pumpHomePage(tester, size: const Size(1280, 1000));

          expect(find.text('Theme Verification Only'), findsOneWidget);
          expect(find.text('Temporary Widget Showcase'), findsOneWidget);
        },
      );
    },
  );
}

Future<void> _pumpHomePage(
  WidgetTester tester, {
  required Size size,
}) async {
  final cubit = TestContentCubit()
    ..emitState(
      ContentState.initial().copyWith(
        status: ContentStatus.loaded,
        resumeOption: some(right(buildResume())),
      ),
    );

  addTearDown(() async {
    await cubit.close();
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;

  await tester.pumpWidget(
    MaterialApp(
      theme: buildAppTheme(),
      home: BlocProvider<ContentCubit>.value(
        value: cubit,
        child: const PortfolioHomePage(),
      ),
    ),
  );
  await tester.pump();
}
