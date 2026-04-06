import 'dart:convert';
import 'dart:io';

import 'package:charlie_shub_portfolio/data/content/asset_content_repository.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<AssetBundle>(as: #MockAssetBundle),
])
import 'asset_content_repository_test.mocks.dart';

void main() {
  group(
    'AssetContentRepository',
    () {
      test(
        'loads single-entry sections from their indices',
        () async {
          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(_loadAllContentAssets()),
          );

          final aboutResult = await repository.loadAbout();
          final resumeResult = await repository.loadResume();
          final about = _expectRight(aboutResult);
          final resume = _expectRight(resumeResult);

          expect(aboutResult.isRight(), isTrue);
          expect(resumeResult.isRight(), isTrue);
          expect(about.slug.getOrCrash(), 'about_me');
          expect(resume.slug.getOrCrash(), 'resume');
        },
      );

      test(
        'loads list sections in the order defined by index.json',
        () async {
          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(_loadAllContentAssets()),
          );

          final projectsResult = await repository.loadProjects();
          final caseStudiesResult = await repository.loadCaseStudies();
          final certificationsResult = await repository.loadCertifications();
          final coursesResult = await repository.loadCourses();
          final projects = _expectSuccessfulSectionItems(projectsResult);
          final caseStudies = _expectSuccessfulSectionItems(caseStudiesResult);
          final certifications = _expectSuccessfulSectionItems(
            certificationsResult,
          );
          final courses = _expectSuccessfulSectionItems(coursesResult);

          expect(projectsResult.isRight(), isTrue);
          expect(caseStudiesResult.isRight(), isTrue);
          expect(certificationsResult.isRight(), isTrue);
          expect(coursesResult.isRight(), isTrue);

          expect(
            projects.map((item) => item.slug.getOrCrash()).toList(),
            <String>['pami', 'world_on'],
          );
          expect(
            caseStudies.map((item) => item.slug.getOrCrash()).toList(),
            <String>[
              'cutting_edge',
              'data_exfiltration_via_agent_tools',
              'frankenstein',
              'notpetya',
              'nullifai',
            ],
          );
          expect(
            certifications.map((item) => item.slug.getOrCrash()).toList(),
            <String>[
              'comptia_security_plus',
              'isc2_certified_in_cybersecurity',
              'ibm_cybersecurity',
              'google_cybersecurity',
            ],
          );
          expect(
            courses.map((item) => item.slug.getOrCrash()).toList(),
            <String>['google_networking'],
          );
        },
      );

      test(
        'uses manifest order when it is provided',
        () async {
          final assets = _loadAllContentAssets()
            ..['assets/content/projects/index.json'] = jsonEncode(
              <String, Object?>{
                'items': <Map<String, Object?>>[
                  <String, Object?>{
                    'file': 'world_on.json',
                    'order': 2,
                  },
                  <String, Object?>{
                    'file': 'pami.json',
                    'order': 1,
                  },
                ],
              },
            );
          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final projectsResult = await repository.loadProjects();
          final projects = _expectSuccessfulSectionItems(projectsResult);

          expect(
            projects.map((item) => item.slug.getOrCrash()).toList(),
            <String>['pami', 'world_on'],
          );
        },
      );

      test(
        'maps a missing section index to assetNotFound',
        () async {
          final assets = _loadAllContentAssets()
            ..remove('assets/content/projects/index.json');
          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadProjects();

          expect(
            result,
            left<AppFailure, List<SectionItemLoad<Project>>>(
              const AppFailure.assetNotFound(
                path: 'assets/content/projects/index.json',
              ),
            ),
          );
        },
      );

      test(
        'keeps valid sibling items when a referenced project file is missing',
        () async {
          final assets = _loadAllContentAssets();
          final index = _decodeJsonObject('assets/content/projects/index.json');
          final items = index['items'] as List<Object?>;
          final rawFirstItem = items.first;
          if (rawFirstItem is Map<Object?, Object?>) {
            final firstItem = Map<String, dynamic>.from(rawFirstItem);
            firstItem['file'] = 'missing_project.json';
            items[0] = firstItem;
          } else {
            fail('Expected the first index item to be a JSON object.');
          }
          assets['assets/content/projects/index.json'] = jsonEncode(index);

          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadProjects();
          final itemResults = _expectRight(result);
          final validSibling = _expectRightItem(itemResults.last);

          expect(
            itemResults.first,
            left<AppFailure, Project>(
              const AppFailure.assetNotFound(
                path: 'assets/content/projects/missing_project.json',
              ),
            ),
          );
          expect(validSibling.slug.getOrCrash(), 'world_on');
        },
      );

      test(
        'maps malformed JSON content to contentLoadError',
        () async {
          final assets = _loadAllContentAssets()
            ..['assets/content/about/about_me.json'] = '{invalid json';
          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadAbout();

          expect(result.isLeft(), isTrue);
          result.fold((failure) {
            expect(
              failure,
              isA<ContentLoadError>().having(
                (value) => value.path,
                'path',
                'assets/content/about/about_me.json',
              ),
            );
          }, (_) => fail('Expected a content load failure.'));
        },
      );

      test(
        'maps malformed index shapes to contentLoadError',
        () async {
          final assets = _loadAllContentAssets()
            ..['assets/content/courses/index.json'] = jsonEncode(
              <String, Object?>{
                'items': 'google_networking.json',
              },
            );
          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadCourses();

          expect(result.isLeft(), isTrue);
          result.fold((failure) {
            expect(
              failure,
              isA<ContentLoadError>().having(
                (value) => value.path,
                'path',
                'assets/content/courses/index.json',
              ),
            );
          }, (_) => fail('Expected a content load failure.'));
        },
      );

      test(
        'maps unsupported rich manifest fields to contentLoadError',
        () async {
          final assets = _loadAllContentAssets()
            ..['assets/content/about/index.json'] = jsonEncode(
              <String, Object?>{
                'items': <Map<String, Object?>>[
                  <String, Object?>{
                    'file': 'about_me.json',
                    'title': 'About Me',
                  },
                ],
              },
            );
          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadAbout();

          expect(result.isLeft(), isTrue);
          result.fold((failure) {
            expect(
              failure,
              isA<ContentLoadError>().having(
                (value) => value.path,
                'path',
                'assets/content/about/index.json',
              ),
            );
          }, (_) => fail('Expected a content load failure.'));
        },
      );

      test(
        'maps missing manifest file fields to contentLoadError',
        () async {
          final assets = _loadAllContentAssets()
            ..['assets/content/about/index.json'] = jsonEncode(
              <String, Object?>{
                'items': <Map<String, Object?>>[
                  <String, Object?>{
                    'order': 1,
                  },
                ],
              },
            );
          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadAbout();

          expect(result.isLeft(), isTrue);
          result.fold((failure) {
            expect(
              failure,
              isA<ContentLoadError>().having(
                (value) => value.path,
                'path',
                'assets/content/about/index.json',
              ),
            );
          }, (_) => fail('Expected a content load failure.'));
        },
      );

      test(
        'fails when the about index resolves to zero files',
        () async {
          final assets = _loadAllContentAssets();
          final index = _decodeJsonObject('assets/content/about/index.json');
          index['items'] = <Object?>[];
          assets['assets/content/about/index.json'] = jsonEncode(index);

          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadAbout();

          expect(result.isLeft(), isTrue);
          result.fold((failure) {
            expect(
              failure,
              isA<ContentLoadError>().having(
                (value) => value.path,
                'path',
                'assets/content/about/index.json',
              ),
            );
          }, (_) => fail('Expected a content load failure.'));
        },
      );

      test(
        'fails when the about index resolves to multiple files',
        () async {
          final assets = _loadAllContentAssets();
          final index = _decodeJsonObject('assets/content/about/index.json');
          (index['items'] as List<Object?>).add(
            <String, Object?>{
              'file': 'about_me.json',
              'order': 1,
            },
          );
          assets['assets/content/about/index.json'] = jsonEncode(index);

          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadAbout();

          expect(result.isLeft(), isTrue);
          result.fold((failure) {
            expect(
              failure,
              isA<ContentLoadError>().having(
                (value) => value.path,
                'path',
                'assets/content/about/index.json',
              ),
            );
          }, (_) => fail('Expected a content load failure.'));
        },
      );

      test(
        'fails when the resume index resolves to zero files',
        () async {
          final assets = _loadAllContentAssets();
          final index = _decodeJsonObject('assets/content/resume/index.json');
          index['items'] = <Object?>[];
          assets['assets/content/resume/index.json'] = jsonEncode(index);

          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadResume();

          expect(result.isLeft(), isTrue);
          result.fold((failure) {
            expect(
              failure,
              isA<ContentLoadError>().having(
                (value) => value.path,
                'path',
                'assets/content/resume/index.json',
              ),
            );
          }, (_) => fail('Expected a content load failure.'));
        },
      );

      test(
        'fails when the resume index resolves to multiple files',
        () async {
          final assets = _loadAllContentAssets();
          final index = _decodeJsonObject('assets/content/resume/index.json');
          (index['items'] as List<Object?>).add(
            <String, Object?>{
              'file': 'resume.json',
              'order': 1,
            },
          );
          assets['assets/content/resume/index.json'] = jsonEncode(index);

          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadResume();

          expect(result.isLeft(), isTrue);
          result.fold((failure) {
            expect(
              failure,
              isA<ContentLoadError>().having(
                (value) => value.path,
                'path',
                'assets/content/resume/index.json',
              ),
            );
          }, (_) => fail('Expected a content load failure.'));
        },
      );

      test(
        'keeps valid sibling items when one project file has the wrong DTO '
        'shape',
        () async {
          final assets = _loadAllContentAssets();
          final project = _decodeJsonObject('assets/content/projects/pami.json')
            ..remove('content');
          assets['assets/content/projects/pami.json'] = jsonEncode(project);

          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadProjects();
          final itemResults = _expectRight(result);
          final validSibling = _expectRightItem(itemResults.last);

          expect(itemResults.first.isLeft(), isTrue);
          itemResults.first.fold((failure) {
            expect(
              failure,
              isA<ContentLoadError>().having(
                (value) => value.path,
                'path',
                'assets/content/projects/pami.json',
              ),
            );
          }, (_) => fail('Expected an item-level content load failure.'));
          expect(validSibling.slug.getOrCrash(), 'world_on');
        },
      );

      test(
        'keeps valid sibling items when one project file has the wrong '
        'meta.type',
        () async {
          final assets = _loadAllContentAssets();
          final project = _decodeJsonObject(
            'assets/content/projects/pami.json',
          );
          final meta = Map<String, dynamic>.from(
            project['meta'] as Map<Object?, Object?>,
          );
          meta['type'] = 'course';
          project['meta'] = meta;
          assets['assets/content/projects/pami.json'] = jsonEncode(project);

          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadProjects();
          final itemResults = _expectRight(result);
          final validSibling = _expectRightItem(itemResults.last);

          expect(itemResults.first.isLeft(), isTrue);
          itemResults.first.fold((failure) {
            expect(
              failure,
              isA<ContentLoadError>().having(
                (value) => value.path,
                'path',
                'assets/content/projects/pami.json',
              ),
            );
          }, (_) => fail('Expected an item-level content load failure.'));
          expect(validSibling.slug.getOrCrash(), 'world_on');
        },
      );

      test(
        'keeps multi-entry section loads successful when an optional link is '
        'invalid inside one project',
        () async {
          final assets = _loadAllContentAssets();
          final project = _decodeJsonObject(
            'assets/content/projects/pami.json',
          );
          final content = Map<String, dynamic>.from(
            project['content'] as Map<Object?, Object?>,
          );
          final rawLinks = List<Object?>.from(
            content['links'] as List<Object?>,
          );
          final rawFirstLink = rawLinks.first;

          if (rawFirstLink is! Map<Object?, Object?>) {
            fail('Expected the first project link to be a JSON object.');
          }
          final firstLink = Map<String, dynamic>.from(rawFirstLink);

          firstLink['url'] = '/relative-url';
          rawLinks[0] = firstLink;
          content['links'] = rawLinks;
          project['content'] = content;
          assets['assets/content/projects/pami.json'] = jsonEncode(project);
          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadProjects();
          final itemResults = _expectRight(result);
          final invalidProject = _expectRightItem(itemResults.first);
          final validSibling = _expectRightItem(itemResults.last);

          expect(result.isRight(), isTrue);
          expect(invalidProject.isValid, isFalse);
          expect(validSibling.isValid, isTrue);
        },
      );

      test(
        'returns successful loads for domain objects that still carry '
        'validation failures',
        () async {
          final assets = _loadAllContentAssets();
          final aboutJson = _decodeJsonObject(
            'assets/content/about/about_me.json',
          );
          final content = Map<String, dynamic>.from(
            aboutJson['content'] as Map<Object?, Object?>,
          );
          content['title'] = '';
          aboutJson['content'] = content;
          assets['assets/content/about/about_me.json'] = jsonEncode(aboutJson);

          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final result = await repository.loadAbout();
          final aboutEntry = _expectRight(result);

          expect(result.isRight(), isTrue);
          expect(aboutEntry.isValid, isFalse);
        },
      );

      test(
        'keeps repository methods independent across content types',
        () async {
          final assets = _loadAllContentAssets()
            ..remove('assets/content/projects/index.json');
          final repository = AssetContentRepository(
            assetBundle: _createAssetBundle(assets),
          );

          final projectsResult = await repository.loadProjects();
          final aboutResult = await repository.loadAbout();

          expect(projectsResult.isLeft(), isTrue);
          expect(aboutResult.isRight(), isTrue);
          projectsResult.fold((failure) {
            expect(
              failure,
              isA<AssetNotFound>().having(
                (value) => value.path,
                'path',
                'assets/content/projects/index.json',
              ),
            );
          }, (_) => fail('Expected the projects load to fail.'));
        },
      );
    },
  );
}

T _expectRight<T>(Either<AppFailure, T> result) => result.fold(
  (failure) => throw StateError('$failure'),
  (value) => value,
);

List<T> _expectSuccessfulSectionItems<T>(MultiEntrySectionLoad<T> result) =>
    _expectRight(result).map(_expectRightItem).toList(growable: false);

T _expectRightItem<T>(SectionItemLoad<T> result) => result.fold(
  (failure) => throw StateError('$failure'),
  (value) => value,
);

Map<String, String> _loadAllContentAssets() {
  final assets = <String, String>{};
  final contentDirectory = Directory('assets/content');

  for (final entity in contentDirectory.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.json')) {
      assets[entity.path] = entity.readAsStringSync();
    }
  }

  return assets;
}

Map<String, dynamic> _decodeJsonObject(String path) =>
    jsonDecode(
          File(path).readAsStringSync(),
        )
        as Map<String, dynamic>;

MockAssetBundle _createAssetBundle(Map<String, String> assets) {
  final assetBundle = MockAssetBundle();

  when(assetBundle.loadString(any, cache: anyNamed('cache'))).thenAnswer((
    invocation,
  ) async {
    final assetPath = invocation.positionalArguments.first as String;
    final value = assets[assetPath];

    if (value != null) {
      return value;
    } else {
      throw Exception('Unable to load asset: $assetPath');
    }
  });

  return assetBundle;
}
