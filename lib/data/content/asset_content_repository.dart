import 'dart:convert';

import 'package:charlie_shub_portfolio/data/core/dtos/about_dto.dart';
import 'package:charlie_shub_portfolio/data/core/dtos/case_study_dto.dart';
import 'package:charlie_shub_portfolio/data/core/dtos/certification_dto.dart';
import 'package:charlie_shub_portfolio/data/core/dtos/course_dto.dart';
import 'package:charlie_shub_portfolio/data/core/dtos/project_dto.dart';
import 'package:charlie_shub_portfolio/data/core/dtos/resume_dto.dart';
import 'package:charlie_shub_portfolio/data/core/dtos/section_manifest_dto.dart';
import 'package:charlie_shub_portfolio/data/core/error/content_loading_exceptions.dart';
import 'package:charlie_shub_portfolio/domain/content/content_repository_interface.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/content_entry_type.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

/// Production content repository backed by Flutter assets.
final class AssetContentRepository implements ContentRepositoryInterface {
  /// Creates a repository that loads structured content from asset JSON files.
  AssetContentRepository({
    AssetBundle? assetBundle,
  }) : _assetBundle = assetBundle ?? rootBundle;

  static const _contentRootPath = 'assets/content';

  final AssetBundle _assetBundle;

  @override
  Future<Either<AppFailure, About>> loadAbout() => _runLoad(
    () => _loadSingleSectionEntry<AboutDto, About>(
      sectionDirectory: 'about',
      expectedType: ContentEntryType.aboutMe,
      parseDto: AboutDto.fromJson,
      mapToDomain: (dto) => dto.toDomain(),
    ),
  );

  @override
  Future<Either<AppFailure, List<Project>>> loadProjects() => _runLoad(
    () => _loadSectionEntries<ProjectDto, Project>(
      sectionDirectory: 'projects',
      expectedType: ContentEntryType.project,
      parseDto: ProjectDto.fromJson,
      mapToDomain: (dto) => dto.toDomain(),
    ),
  );

  @override
  Future<Either<AppFailure, List<CaseStudy>>> loadCaseStudies() => _runLoad(
    () => _loadSectionEntries<CaseStudyDto, CaseStudy>(
      sectionDirectory: 'case_studies',
      expectedType: ContentEntryType.caseStudy,
      parseDto: CaseStudyDto.fromJson,
      mapToDomain: (dto) => dto.toDomain(),
    ),
  );

  @override
  Future<Either<AppFailure, List<Certification>>> loadCertifications() =>
      _runLoad(
        () => _loadSectionEntries<CertificationDto, Certification>(
          sectionDirectory: 'certifications',
          expectedType: ContentEntryType.certificate,
          parseDto: CertificationDto.fromJson,
          mapToDomain: (dto) => dto.toDomain(),
        ),
      );

  @override
  Future<Either<AppFailure, List<Course>>> loadCourses() => _runLoad(
    () => _loadSectionEntries<CourseDto, Course>(
      sectionDirectory: 'courses',
      expectedType: ContentEntryType.course,
      parseDto: CourseDto.fromJson,
      mapToDomain: (dto) => dto.toDomain(),
    ),
  );

  @override
  Future<Either<AppFailure, Resume>> loadResume() => _runLoad(
    () => _loadSingleSectionEntry<ResumeDto, Resume>(
      sectionDirectory: 'resume',
      expectedType: ContentEntryType.resume,
      parseDto: ResumeDto.fromJson,
      mapToDomain: (dto) => dto.toDomain(),
    ),
  );

  /// Wraps internal loading work and maps helper exceptions into the public
  /// failure types exposed by the repository interface.
  Future<Either<AppFailure, T>> _runLoad<T>(
    Future<T> Function() load,
  ) async {
    try {
      return right(await load());
    } on AssetNotFoundException catch (error) {
      return left(AppFailure.assetNotFound(path: error.path));
    } on ContentLoadException catch (error) {
      return left(
        AppFailure.contentLoadError(
          path: error.path,
          errorString: error.errorString,
        ),
      );
    } on Object catch (error) {
      return left(
        AppFailure.unexpectedError(
          errorString: error.toString(),
        ),
      );
    }
  }

  /// Loads a section that should reference exactly one entry from its
  /// `index.json`, such as `about` or `resume`.
  Future<T> _loadSingleSectionEntry<TDto, T>({
    required String sectionDirectory,
    required ContentEntryType expectedType,
    required TDto Function(Map<String, dynamic> json) parseDto,
    required T Function(TDto dto) mapToDomain,
  }) async {
    final indexPath = _buildIndexPath(sectionDirectory);
    final manifestItems = await _loadSectionManifestItems(sectionDirectory);

    if (manifestItems.length == 1) {
      return _loadSectionEntry(
        sectionDirectory: sectionDirectory,
        fileName: manifestItems.single.file,
        expectedType: expectedType,
        parseDto: parseDto,
        mapToDomain: mapToDomain,
      );
    } else {
      throw ContentLoadException(
        path: indexPath,
        errorString:
            'Expected exactly 1 item in $indexPath, found '
            '${manifestItems.length}.',
      );
    }
  }

  /// Loads every content file referenced by a section index, preserving the
  /// order declared by the lightweight section manifest.
  Future<List<T>> _loadSectionEntries<TDto, T>({
    required String sectionDirectory,
    required ContentEntryType expectedType,
    required TDto Function(Map<String, dynamic> json) parseDto,
    required T Function(TDto dto) mapToDomain,
  }) async {
    final manifestItems = await _loadSectionManifestItems(sectionDirectory);
    final items = <T>[];

    for (final manifestItem in manifestItems) {
      final item = await _loadSectionEntry<TDto, T>(
        sectionDirectory: sectionDirectory,
        fileName: manifestItem.file,
        expectedType: expectedType,
        parseDto: parseDto,
        mapToDomain: mapToDomain,
      );
      items.add(item);
    }

    return items;
  }

  /// Loads one content file, checks its runtime type, and converts it from DTO
  /// into the corresponding domain object.
  Future<T> _loadSectionEntry<TDto, T>({
    required String sectionDirectory,
    required String fileName,
    required ContentEntryType expectedType,
    required TDto Function(Map<String, dynamic> json) parseDto,
    required T Function(TDto dto) mapToDomain,
  }) async {
    final assetPath = _buildSectionAssetPath(
      sectionDirectory: sectionDirectory,
      fileName: fileName,
    );
    final decodedJson = await _loadJsonObject(assetPath);

    _ensureExpectedType(
      decodedJson,
      assetPath: assetPath,
      expectedType: expectedType,
    );

    try {
      final dto = parseDto(decodedJson);
      return mapToDomain(dto);
    } on Object catch (error) {
      throw ContentLoadException(
        path: assetPath,
        errorString: error.toString(),
      );
    }
  }

  /// Reads a section `index.json` manifest and returns its ordered entries.
  ///
  /// The manifest is intentionally lightweight. It is used for section
  /// discovery and small curation hints such as `order`, while each referenced
  /// entry file remains authoritative for the actual content payload.
  Future<List<SectionManifestItemDto>> _loadSectionManifestItems(
    String sectionDirectory,
  ) async {
    final indexPath = _buildIndexPath(sectionDirectory);
    final decodedJson = await _loadJsonObject(indexPath);

    try {
      final manifest = SectionManifestDto.fromJson(decodedJson);

      return _orderManifestItems(manifest.items);
    } on Object catch (error) {
      throw ContentLoadException(
        path: indexPath,
        errorString: error.toString(),
      );
    }
  }

  List<SectionManifestItemDto> _orderManifestItems(
    List<SectionManifestItemDto> manifestItems,
  ) {
    final sortedIndexedItems =
        manifestItems.asMap().entries.toList(
          growable: false,
        )..sort((first, second) {
          final firstOrder = first.value.order ?? first.key;
          final secondOrder = second.value.order ?? second.key;
          final orderComparison = firstOrder.compareTo(secondOrder);

          if (orderComparison != 0) {
            return orderComparison;
          } else {
            return first.key.compareTo(second.key);
          }
        });

    return sortedIndexedItems
        .map((entry) => entry.value)
        .toList(growable: false);
  }

  /// Loads and decodes a JSON asset, enforcing a top-level object shape before
  /// handing the data to the DTO layer.
  Future<Map<String, dynamic>> _loadJsonObject(String assetPath) async {
    final rawJson = await _loadAssetString(assetPath);

    try {
      final decodedJson = jsonDecode(rawJson);

      if (decodedJson is Map<Object?, Object?>) {
        return Map<String, dynamic>.from(decodedJson);
      } else {
        throw ContentLoadException(
          path: assetPath,
          errorString: 'Expected a top-level JSON object.',
        );
      }
    } on ContentLoadException {
      rethrow;
    } on Object catch (error) {
      throw ContentLoadException(
        path: assetPath,
        errorString: error.toString(),
      );
    }
  }

  /// Loads the raw string for an asset path and classifies missing-asset cases
  /// separately from broader content-loading failures.
  Future<String> _loadAssetString(String assetPath) async {
    try {
      return await _assetBundle.loadString(assetPath);
    } on Object catch (error) {
      if (_isMissingAssetError(error)) {
        throw AssetNotFoundException(path: assetPath);
      } else {
        throw ContentLoadException(
          path: assetPath,
          errorString: error.toString(),
        );
      }
    }
  }

  /// Verifies that a decoded content object declares the expected `meta.type`
  /// for the section currently being loaded.
  void _ensureExpectedType(
    Map<String, dynamic> decodedJson, {
    required String assetPath,
    required ContentEntryType expectedType,
  }) {
    final rawMeta = decodedJson['meta'];
    if (rawMeta is Map<Object?, Object?>) {
      final rawType = rawMeta['type'];

      if (rawType is String) {
        if (rawType == expectedType.jsonValue) {
          return;
        } else {
          throw ContentLoadException(
            path: assetPath,
            errorString:
                'Expected meta.type ${expectedType.jsonValue} but found '
                '$rawType.',
          );
        }
      } else {
        throw ContentLoadException(
          path: assetPath,
          errorString: 'Content file meta.type must be a string.',
        );
      }
    } else {
      throw ContentLoadException(
        path: assetPath,
        errorString: 'Content file is missing a valid meta object.',
      );
    }
  }

  /// Builds the asset path to a section's `index.json` file.
  String _buildIndexPath(String sectionDirectory) =>
      '$_contentRootPath/$sectionDirectory/index.json';

  /// Builds the asset path to a content entry file inside a section folder.
  String _buildSectionAssetPath({
    required String sectionDirectory,
    required String fileName,
  }) => '$_contentRootPath/$sectionDirectory/$fileName';

  /// Detects common asset-loader error messages that indicate a missing file
  /// in the Flutter asset bundle.
  bool _isMissingAssetError(Object error) {
    final errorString = error.toString();

    return errorString.contains('Unable to load asset') ||
        errorString.contains('does not exist') ||
        errorString.contains('asset does not exist');
  }
}
