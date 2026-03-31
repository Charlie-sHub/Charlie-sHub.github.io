import 'package:charlie_shub_portfolio/domain/core/entities/case_study_atlas_mapping.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'CaseStudyAtlasMapping',
    () {
      test(
        'is valid with only the required summary',
        () {
          final mapping = CaseStudyAtlasMapping(
            summary: NonEmptyText('ATLAS does not apply to this incident.'),
          );

          expect(mapping.isValid, isTrue);
        },
      );

      test(
        'is invalid when the summary is invalid',
        () {
          final mapping = CaseStudyAtlasMapping(
            summary: NonEmptyText('   '),
          );

          expect(mapping.isValid, isFalse);
          expect(mapping.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
