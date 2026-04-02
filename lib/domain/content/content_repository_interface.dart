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
/// and composing the resulting app state. This interface exposes domain
/// entities that may still carry invalid fields or an [AppFailure].
abstract class ContentRepositoryInterface {
  /// Loads the single about entry for the website.
  Future<Either<AppFailure, About>> loadAbout();

  /// Loads the project entries for the website.
  Future<Either<AppFailure, List<Project>>> loadProjects();

  /// Loads the security case study entries for the website.
  Future<Either<AppFailure, List<CaseStudy>>> loadCaseStudies();

  /// Loads the certification entries for the website.
  Future<Either<AppFailure, List<Certification>>> loadCertifications();

  /// Loads the course entries for the website.
  Future<Either<AppFailure, List<Course>>> loadCourses();

  /// Loads the single resume entry for the website.
  Future<Either<AppFailure, Resume>> loadResume();
}
