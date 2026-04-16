import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/home_page.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_theme.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/gestures.dart';
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
          final aboutRect = tester.getRect(find.text('About'));

          expect(find.text('Carlos Mendez'), findsAtLeastNWidgets(1));
          expect(profileRect.left, lessThan(aboutRect.left));
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
          final aboutRect = tester.getRect(find.text('About'));

          expect(find.text('Carlos Mendez'), findsAtLeastNWidgets(1));
          expect(profileRect.top, lessThan(aboutRect.top));
        },
      );

      testWidgets(
        'omits temporary showcase and scaffolding sections '
        'from the public home page',
        (tester) async {
          await _pumpHomePage(tester, size: const Size(1280, 1000));

          expect(find.text('Theme Verification Only'), findsNothing);
          expect(find.text('Temporary Widget Showcase'), findsNothing);
          expect(find.text('Portfolio Overview'), findsNothing);
          expect(find.text('Current setup'), findsNothing);
        },
      );

      testWidgets(
        'orders core sections from flagship proof to supporting content',
        (tester) async {
          await _pumpHomePage(tester, size: const Size(1280, 2800));

          final projectsTop = tester.getTopLeft(find.text('Projects')).dy;
          final caseStudiesTop = tester
              .getTopLeft(find.text('Case Studies'))
              .dy;
          final certificationsTop = tester
              .getTopLeft(find.text('Certifications'))
              .dy;
          final coursesTop = tester.getTopLeft(find.text('Courses')).dy;
          final aboutTop = tester.getTopLeft(find.text('About')).dy;
          final resumeTop = tester.getTopLeft(find.text('Resume')).dy;

          expect(projectsTop, lessThan(caseStudiesTop));
          expect(caseStudiesTop, lessThan(certificationsTop));
          expect(certificationsTop, lessThan(coursesTop));
          expect(coursesTop, lessThan(aboutTop));
          expect(aboutTop, lessThan(resumeTop));
        },
      );

      testWidgets(
        'scrolls the wide page even when the pointer is over the sticky '
        'profile summary lane',
        (tester) async {
          await _pumpHomePage(tester, size: const Size(1440, 700));

          final summaryRect = tester.getRect(
            find.byKey(const ValueKey<String>('home-profile-summary')),
          );
          final aboutRectBefore = tester.getRect(find.text('About'));

          final pointer = TestPointer(1, PointerDeviceKind.mouse);
          await tester.sendEventToBinding(pointer.hover(summaryRect.center));
          await tester.sendEventToBinding(
            pointer.scroll(const Offset(0, 240)),
          );
          await tester.pump();

          final aboutRectAfter = tester.getRect(find.text('About'));

          expect(aboutRectAfter.top, lessThan(aboutRectBefore.top));
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
