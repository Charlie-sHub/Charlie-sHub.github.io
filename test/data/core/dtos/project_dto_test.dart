import 'package:charlie_shub_portfolio/data/core/dtos/project_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dto_test_utils.dart';

void main() {
  group(
    'ProjectDto',
    () {
      test(
        'maps a project with media assets into domain',
        () {
          final json = loadJsonFixture('assets/content/projects/world_on.json');

          final dto = ProjectDto.fromJson(json);
          final project = dto.toDomain();

          expect(project.isValid, isTrue);
          expect(project.slug.getOrCrash(), 'world_on');
          expect(
            project.thumbnailPath?.getOrCrash(),
            'assets/media/content/projects/world_on/world_on_home_and_search'
            '.png',
          );
          expect(project.galleryImagePaths, hasLength(4));
        },
      );

      test(
        'maps a project with optional media absent into empty or null '
        'domain fields',
        () {
          final json = loadJsonFixture('assets/content/projects/pami.json');

          final dto = ProjectDto.fromJson(json);
          final project = dto.toDomain();

          expect(project.thumbnailPath, isNull);
          expect(project.heroImagePath, isNull);
          expect(project.galleryImagePaths, isEmpty);
          expect(project.links, hasLength(1));
          expect(
            project.links.single.url.getOrCrash(),
            'https://github.com/Charlie-sHub/pami',
          );
        },
      );

      test(
        'maps external project links from links into domain',
        () {
          final json = loadJsonFixture('assets/content/projects/pami.json');
          final content = json['content'] as Map<String, dynamic>;
          content['links'] = <Map<String, dynamic>>[
            <String, dynamic>{
              'label': 'Repository',
              'url': 'https://github.com/Charlie-sHub/portfolio',
            },
            <String, dynamic>{
              'label': 'Website',
              'url': 'https://example.com',
            },
          ];

          final dto = ProjectDto.fromJson(json);
          final project = dto.toDomain();

          expect(project.links, hasLength(2));
          expect(
            project.links.first.url.getOrCrash(),
            'https://github.com/Charlie-sHub/portfolio',
          );
        },
      );

      test(
        'throws during JSON parsing when stack has the wrong type',
        () {
          final json = loadJsonFixture('assets/content/projects/pami.json');
          final content = json['content'] as Map<String, dynamic>;
          content['stack'] = 'Flutter';

          expect(
            () => ProjectDto.fromJson(json),
            throwsA(isA<CheckedFromJsonException>()),
          );
        },
      );

      test(
        'maps invalid project links into an invalid domain object',
        () {
          final json = loadJsonFixture('assets/content/projects/pami.json');
          final content = json['content'] as Map<String, dynamic>;
          content['links'] = <Map<String, dynamic>>[
            <String, dynamic>{
              'label': 'Repository',
              'url': '/relative-url',
            },
          ];

          final dto = ProjectDto.fromJson(json);
          final project = dto.toDomain();

          expect(project.isValid, isFalse);
          expect(project.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
