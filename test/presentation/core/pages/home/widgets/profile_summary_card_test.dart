import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/profile_summary_card.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../application/content/content_test_entity_builders.dart';
import '../../../presentation_test_helpers.dart';

void main() {
  group(
    'ProfileSummaryCard',
    () {
      testWidgets(
        'shows email directly and omits the portfolio self-link',
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
          expect(find.text('carlosrafael-mg@hotmail.com'), findsOneWidget);
          expect(find.text('Write'), findsOneWidget);
          expect(find.text('LinkedIn'), findsOneWidget);
          expect(find.text('Portfolio'), findsNothing);
        },
      );
    },
  );
}
