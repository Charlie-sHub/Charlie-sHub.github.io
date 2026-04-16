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
          expect(
            resume.contactLinks.map((link) => link.label.getOrCrash()).toList(),
            <String>['LinkedIn', 'GitHub'],
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
        'accepts an explicit null end_date for an ongoing experience item',
        () {
          final json = loadJsonFixture('assets/content/resume/resume.json');
          final content = json['content'] as Map<String, dynamic>;
          final experienceItems =
              content['professional_experience'] as List<dynamic>;
          final firstExperienceItem =
              experienceItems.first as Map<String, dynamic>;

          firstExperienceItem['is_ongoing'] = true;
          firstExperienceItem['end_date'] = null;

          final dto = ResumeDto.fromJson(json);
          final resume = dto.toDomain();

          expect(resume.isValid, isTrue);
          expect(resume.professionalExperience.first.endDate, isNull);
        },
      );

      test(
        'throws during JSON parsing when an experience item omits the '
        'required end_date key',
        () {
          final json = loadJsonFixture('assets/content/resume/resume.json');
          final content = json['content'] as Map<String, dynamic>;
          final experienceItems =
              content['professional_experience'] as List<dynamic>;
          (experienceItems.first as Map<String, dynamic>).remove('end_date');

          expect(
            () => ResumeDto.fromJson(json),
            throwsA(isA<CheckedFromJsonException>()),
          );
        },
      );

      test(
        'maps an explicit null end_date for a completed experience item into '
        'an invalid domain object',
        () {
          final json = loadJsonFixture('assets/content/resume/resume.json');
          final content = json['content'] as Map<String, dynamic>;
          final experienceItems =
              content['professional_experience'] as List<dynamic>;
          final firstExperienceItem =
              experienceItems.first as Map<String, dynamic>;

          firstExperienceItem['is_ongoing'] = false;
          firstExperienceItem['end_date'] = null;

          final dto = ResumeDto.fromJson(json);
          final resume = dto.toDomain();

          expect(resume.isValid, isFalse);
          expect(resume.failureOption.isSome(), isTrue);
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
