import 'package:charlie_shub_portfolio/data/core/dtos/course_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dto_test_utils.dart';

void main() {
  group(
    'CourseDto',
    () {
      test(
        'maps a course with null assets and absent proof into domain',
        () {
          final json = loadJsonFixture(
            'assets/content/courses/google_networking.json',
          );

          final dto = CourseDto.fromJson(json);
          final course = dto.toDomain();

          expect(course.isValid, isTrue);
          expect(course.slug.getOrCrash(), 'google_networking');
          expect(course.badgeImagePath, isNull);
          expect(course.certificatePdfPath, isNull);
          expect(course.proof, isEmpty);
          expect(course.keyTakeaways, isNotEmpty);
        },
      );

      test(
        'throws during JSON parsing when topics_covered has the wrong type',
        () {
          final json = loadJsonFixture(
            'assets/content/courses/google_networking.json',
          );
          final content = json['content'] as Map<String, dynamic>;
          content['topics_covered'] = 'not-a-list';

          expect(
            () => CourseDto.fromJson(json),
            throwsA(isA<CheckedFromJsonException>()),
          );
        },
      );

      test(
        'maps invalid asset paths into an invalid domain object',
        () {
          final json = loadJsonFixture(
            'assets/content/courses/google_networking.json',
          );
          final content = json['content'] as Map<String, dynamic>;
          content['badgeImagePath'] = 'assets/documents/not-a-media-path.pdf';

          final dto = CourseDto.fromJson(json);
          final course = dto.toDomain();

          expect(course.isValid, isFalse);
          expect(course.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
