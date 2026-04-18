import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/profile_summary_card.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart' show TextButton, ValueKey;
import 'package:flutter_test/flutter_test.dart';

import '../../../../../application/content/content_test_entity_builders.dart';
import '../../../presentation_test_helpers.dart';

void main() {
  group(
    'ProfileSummaryCard',
    () {
      testWidgets(
        'shows the sticky image and contact actions without location or the '
        'portfolio self-link',
        (tester) async {
          final resume = buildResume().copyWith(
            contactLinks: <LinkReference>[
              LinkReference(
                label: SingleLineText('LinkedIn'),
                url: UrlValue('https://example.com/linkedin'),
              ),
              LinkReference(
                label: SingleLineText('Portfolio'),
                url: UrlValue('https://charlie-shub.github.io'),
              ),
            ],
          );

          await pumpWithContentState(
            tester,
            child: const ProfileSummaryCard(),
            state: ContentState.initial().copyWith(
              status: ContentStatus.loaded,
              resumeOption: some(right(resume)),
            ),
          );

          expect(find.text('Email'), findsOneWidget);
          expect(find.text('LinkedIn'), findsOneWidget);
          expect(find.text('Portfolio'), findsNothing);
          expect(find.text('Madrid, Spain'), findsNothing);
          expect(find.text('carlosrafael-mg@hotmail.com'), findsNothing);
          expect(find.text('Write'), findsNothing);
          expect(find.text('Open link'), findsNothing);
          expect(
            find.byKey(
              const ValueKey<String>('profile-summary-inner-card'),
            ),
            findsOneWidget,
          );
          expect(
            find.byKey(
              const ValueKey<String>('profile-summary-image'),
            ),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'stretches sticky contact buttons to the available summary width',
        (tester) async {
          final resume = buildResume().copyWith(
            contactLinks: <LinkReference>[
              LinkReference(
                label: SingleLineText('LinkedIn'),
                url: UrlValue('https://example.com/linkedin'),
              ),
              LinkReference(
                label: SingleLineText('GitHub'),
                url: UrlValue('https://example.com/github'),
              ),
            ],
          );

          await pumpWithContentState(
            tester,
            child: const ProfileSummaryCard(),
            state: ContentState.initial().copyWith(
              status: ContentStatus.loaded,
              resumeOption: some(right(resume)),
            ),
            width: 320,
          );

          final emailWidth = tester
              .getSize(find.widgetWithText(TextButton, 'Email'))
              .width;
          final linkedInWidth = tester
              .getSize(find.widgetWithText(TextButton, 'LinkedIn'))
              .width;
          final gitHubWidth = tester
              .getSize(find.widgetWithText(TextButton, 'GitHub'))
              .width;

          expect(linkedInWidth, emailWidth);
          expect(gitHubWidth, emailWidth);
        },
      );

      testWidgets(
        'uses the short about summary instead of the longer resume summary',
        (tester) async {
          final about = buildAbout().copyWith(
            professionalSummaryShort: NonEmptyText(
              'Short summary for the sticky profile card.',
            ),
          );
          final resume = buildResume().copyWith(
            summary: NonEmptyText(
              'Longer resume summary that should not appear in the sticky '
              'profile card when the about summary is available.',
            ),
          );

          await pumpWithContentState(
            tester,
            child: const ProfileSummaryCard(),
            state: ContentState.initial().copyWith(
              status: ContentStatus.loaded,
              aboutOption: some(right(about)),
              resumeOption: some(right(resume)),
            ),
          );

          expect(
            find.text('Short summary for the sticky profile card.'),
            findsOneWidget,
          );
          expect(
            find.textContaining('Longer resume summary'),
            findsNothing,
          );
        },
      );

      testWidgets(
        'falls back to the resume summary when the about short summary is '
        'absent',
        (tester) async {
          final about = buildAbout().copyWith(
            professionalSummaryShort: null,
          );
          final resume = buildResume().copyWith(
            summary: NonEmptyText(
              'Resume summary fallback for the sticky profile card.',
            ),
          );

          await pumpWithContentState(
            tester,
            child: const ProfileSummaryCard(),
            state: ContentState.initial().copyWith(
              status: ContentStatus.loaded,
              aboutOption: some(right(about)),
              resumeOption: some(right(resume)),
            ),
          );

          expect(
            find.text('Resume summary fallback for the sticky profile card.'),
            findsOneWidget,
          );
        },
      );
    },
  );
}
