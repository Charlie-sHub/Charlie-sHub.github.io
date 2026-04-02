import 'package:charlie_shub_portfolio/data/core/dtos/case_study_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dto_test_utils.dart';

void main() {
  group(
    'CaseStudyDto',
    () {
      test(
        'maps a full case study with ATLAS and indicators into domain',
        () {
          final json = loadJsonFixture(
            'assets/content/case_studies/cutting_edge.json',
          );

          final dto = CaseStudyDto.fromJson(json);
          final caseStudy = dto.toDomain();

          expect(caseStudy.isValid, isTrue);
          expect(caseStudy.slug.getOrCrash(), 'cutting_edge');
          expect(caseStudy.atlasMapping, isNotNull);
          expect(caseStudy.indicators, isNotNull);
          expect(caseStudy.references, isNotEmpty);
        },
      );

      test(
        'keeps optional indicators absent when the JSON does not define them',
        () {
          final json = loadJsonFixture(
            'assets/content/case_studies/data_exfiltration_via_agent_tools.json',
          );

          final dto = CaseStudyDto.fromJson(json);
          final caseStudy = dto.toDomain();

          expect(caseStudy.atlasMapping, isNotNull);
          expect(caseStudy.indicators, isNull);
        },
      );

      test(
        'throws during JSON parsing when references have the wrong shape',
        () {
          final json = loadJsonFixture(
            'assets/content/case_studies/cutting_edge.json',
          );
          final content = json['content'] as Map<String, dynamic>;
          content['references'] = 'not-a-list';

          expect(
            () => CaseStudyDto.fromJson(json),
            throwsA(isA<CheckedFromJsonException>()),
          );
        },
      );

      test(
        'maps invalid reference URLs into an invalid domain object',
        () {
          final json = loadJsonFixture(
            'assets/content/case_studies/cutting_edge.json',
          );
          final content = json['content'] as Map<String, dynamic>;
          final references = content['references'] as List<dynamic>;
          final firstReference = references.first as Map<String, dynamic>;
          firstReference['url'] = '/relative-url';

          final dto = CaseStudyDto.fromJson(json);
          final caseStudy = dto.toDomain();

          expect(caseStudy.isValid, isFalse);
          expect(caseStudy.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
