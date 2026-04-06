import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:dartz/dartz.dart';

/// Loads website content one section at a time.
///
/// The application layer is responsible for calling these methods separately
/// and composing the resulting app state.
///
/// A successful `Right` means the asset was found, decoded, deserialized, and
/// mapped into domain data. The returned entity may still carry validation
/// failures on individual fields or nested items so presentation can later
/// decide how to degrade locally.
///
/// For multi-entry sections, an outer `Right` means the section manifest loaded
/// successfully. Individual entries inside that `Right` may still be `Left`
/// item-level load failures.
///
/// A `Left` is reserved for broader load failures such as missing assets,
/// malformed JSON, or DTO-deserialization problems represented by
/// [AppFailure].
abstract class ContentRepositoryInterface {
  /// Loads the single about entry for the website.
  Future<Either<AppFailure, About>> loadAbout();

  /// Loads the project entries for the website.
  Future<MultiEntrySectionLoad<Project>> loadProjects();

  /// Loads the security case study entries for the website.
  Future<MultiEntrySectionLoad<CaseStudy>> loadCaseStudies();

  /// Loads the certification entries for the website.
  Future<MultiEntrySectionLoad<Certification>> loadCertifications();

  /// Loads the course entries for the website.
  Future<MultiEntrySectionLoad<Course>> loadCourses();

  /// Loads the single resume entry for the website.
  Future<Either<AppFailure, Resume>> loadResume();
}
