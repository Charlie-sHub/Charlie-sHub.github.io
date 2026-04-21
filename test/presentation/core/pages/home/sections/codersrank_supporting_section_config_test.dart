import 'package:charlie_shub_portfolio/presentation/core/pages/home/sections/codersrank_supporting_section_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'CodersRankSupportingSectionConfig',
    () {
      test(
        'keeps the retained browser-only script configuration explicit',
        () {
          expect(CodersRankSupportingSectionConfig.username, 'charlie-shub');
          expect(
            CodersRankSupportingSectionConfig.summaryTagName,
            'codersrank-summary',
          );
          expect(
            CodersRankSupportingSectionConfig.summaryScriptId,
            'codersrank-summary-script',
          );
          expect(
            CodersRankSupportingSectionConfig.summaryScriptUrl,
            'https://unpkg.com/@codersrank/summary@0.9.13/'
            'codersrank-summary.min.js',
          );
          expect(
            CodersRankSupportingSectionConfig.registrationPollInterval,
            const Duration(milliseconds: 150),
          );
          expect(
            CodersRankSupportingSectionConfig.registrationTimeout,
            const Duration(seconds: 8),
          );
          expect(
            CodersRankSupportingSectionConfig.renderTimeout,
            const Duration(seconds: 8),
          );
        },
      );
    },
  );
}
