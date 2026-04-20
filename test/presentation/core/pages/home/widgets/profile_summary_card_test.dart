import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/profile_summary_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart' show Icons, Text, TextButton, ValueKey;
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
        'lays out the name and profile image in the same header row',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const ProfileSummaryCard(),
            state: ContentState.initial().copyWith(
              status: ContentStatus.loaded,
              resumeOption: some(right(buildResume())),
            ),
            width: 320,
          );

          final nameText = tester.widget<Text>(find.text('Carlos Mendez'));
          final nameRect = tester.getRect(find.text('Carlos Mendez'));
          final imageRect = tester.getRect(
            find.byKey(const ValueKey<String>('profile-summary-image')),
          );

          expect(nameText.maxLines, 2);
          expect(imageRect.left, greaterThan(nameRect.left));
          expect(imageRect.top, lessThan(nameRect.bottom));
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
        'keeps sticky contact button content aligned with shared icon slots',
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

          final emailButtonRect = tester.getRect(
            find.widgetWithText(TextButton, 'Email'),
          );
          final linkedInButtonRect = tester.getRect(
            find.widgetWithText(TextButton, 'LinkedIn'),
          );
          final gitHubButtonRect = tester.getRect(
            find.widgetWithText(TextButton, 'GitHub'),
          );
          final emailIconRect = tester.getRect(
            find.byIcon(Icons.mail_outline_rounded),
          );
          final linkedInIconRect = tester.getRect(
            find.byIcon(Icons.badge_outlined),
          );
          final gitHubIconRect = tester.getRect(
            find.byIcon(Icons.code_rounded),
          );

          expect(emailIconRect.left, linkedInIconRect.left);
          expect(gitHubIconRect.left, linkedInIconRect.left);
          expect(emailIconRect.left, greaterThan(emailButtonRect.left));
          expect(linkedInIconRect.left, greaterThan(linkedInButtonRect.left));
          expect(gitHubIconRect.left, greaterThan(gitHubButtonRect.left));
          expect(
            tester.getRect(find.text('Email')).left - emailIconRect.right,
            AppSpacing.size8,
          );
          expect(
            tester.getRect(find.text('LinkedIn')).left - linkedInIconRect.right,
            AppSpacing.size8,
          );
          expect(
            tester.getRect(find.text('GitHub')).left - gitHubIconRect.right,
            AppSpacing.size8,
          );
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
