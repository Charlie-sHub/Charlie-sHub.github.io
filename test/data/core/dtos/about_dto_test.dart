import 'package:charlie_shub_portfolio/data/core/dtos/about_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dto_test_utils.dart';

void main() {
  group(
    'AboutDto',
    () {
      test(
        'deserializes and maps the about entry into a valid domain object',
        () {
          final json = loadJsonFixture('assets/content/about/about_me.json');

          final dto = AboutDto.fromJson(json);
          final about = dto.toDomain();

          expect(about.isValid, isTrue);
          expect(about.slug.getOrCrash(), 'about_me');
          expect(about.title.getOrCrash(), 'About Me');
          expect(about.selectedSkillsAndTools, hasLength(5));
        },
      );

      test(
        'throws during JSON parsing when the required content block is missing',
        () {
          final json = loadJsonFixture('assets/content/about/about_me.json')
            ..remove('content');

          expect(
            () => AboutDto.fromJson(json),
            throwsA(isA<CheckedFromJsonException>()),
          );
        },
      );

      test(
        'maps invalid title data into an invalid domain object',
        () {
          final json = loadJsonFixture('assets/content/about/about_me.json');
          final content = json['content'] as Map<String, dynamic>;
          content['title'] = '';

          final dto = AboutDto.fromJson(json);
          final about = dto.toDomain();

          expect(about.isValid, isFalse);
          expect(about.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
