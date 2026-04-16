import 'package:charlie_shub_portfolio/presentation/core/theme/app_codersrank_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'AppCodersRankTheme',
    () {
      test(
        'keeps the summary badge spacing row-friendly across viewport modes',
        () {
          final regularVariables = AppCodersRankTheme.summaryVariables(
            isCompact: false,
          );
          final compactVariables = AppCodersRankTheme.summaryVariables(
            isCompact: true,
          );

          expect(regularVariables['--badge-margin'], '10px');
          expect(compactVariables['--badge-margin'], '10px');
        },
      );

      test(
        'gives the compact rank-widget fallback extra vertical space',
        () {
          expect(
            AppCodersRankTheme.rankWidgetHeightFor(isCompact: false),
            176,
          );
          expect(
            AppCodersRankTheme.rankWidgetHeightFor(isCompact: true),
            248,
          );
        },
      );
    },
  );
}
