import 'package:charlie_shub_portfolio/data/core/dtos/resume_dto.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/language_proficiency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dto_test_utils.dart';

void main() {
  group(
    'ResumeDto',
    () {
      test(
        'maps the resume entry into a valid domain object',
        () {
          final json = loadJsonFixture('assets/content/resume/resume.json');

          final dto = ResumeDto.fromJson(json);
          final resume = dto.toDomain();

          expect(resume.isValid, isTrue);
          expect(resume.slug.getOrCrash(), 'resume');
          expect(
            resume.resumePdfPath?.getOrCrash(),
            'assets/documents/resume/carlos_mendez_dev.pdf',
          );
          expect(resume.professionalExperience.first.organization, isNull);
          expect(
            resume.professionalExperience[1].organization?.getOrCrash(),
            'Media Mechanics',
          );
        },
      );

      test(
        'throws during JSON parsing when contact_links is missing',
        () {
          final json = loadJsonFixture('assets/content/resume/resume.json');
          (json['content'] as Map<String, dynamic>).remove('contact_links');

          expect(
            () => ResumeDto.fromJson(json),
            throwsA(isA<CheckedFromJsonException>()),
          );
        },
      );

      test(
        'accepts every schema-aligned proficiency value at the DTO boundary',
        () {
          for (final supportedValue
              in LanguageProficiency.supportedJsonValues) {
            final json = loadJsonFixture('assets/content/resume/resume.json');
            final content = json['content'] as Map<String, dynamic>;
            final languages = content['languages'] as List<dynamic>;
            final firstLanguage = languages.first as Map<String, dynamic>;
            firstLanguage['proficiency'] = supportedValue;

            final dto = ResumeDto.fromJson(json);
            final resume = dto.toDomain();

            expect(resume.isValid, isTrue);
            expect(
              resume.languages.first.proficiency.jsonValue,
              supportedValue,
            );
          }
        },
      );

      test(
        'maps unsupported proficiency strings into an invalid domain object',
        () {
          final json = loadJsonFixture('assets/content/resume/resume.json');
          final content = json['content'] as Map<String, dynamic>;
          final languages = content['languages'] as List<dynamic>;
          final firstLanguage = languages.first as Map<String, dynamic>;
          firstLanguage['proficiency'] = 'Expert';

          final dto = ResumeDto.fromJson(json);
          final resume = dto.toDomain();

          expect(resume.isValid, isFalse);
          expect(resume.failureOption.isSome(), isTrue);
          expect(
            resume.languages.first.proficiency,
            LanguageProficiency.invalid,
          );
        },
      );
    },
  );
}
