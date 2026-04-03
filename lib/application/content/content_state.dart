import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_state.freezed.dart';

/// Flat application state for public portfolio content loading.
@freezed
abstract class ContentState with _$ContentState {
  /// Creates the content application state.
  const factory ContentState({
    required ContentStatus status,
    required Option<AppFailure> failureOption,
    required Option<Either<AppFailure, About>> aboutOption,
    required Option<Either<AppFailure, List<Project>>> projectsOption,
    required Option<Either<AppFailure, List<CaseStudy>>> caseStudiesOption,
    required Option<Either<AppFailure, List<Certification>>>
    certificationsOption,
    required Option<Either<AppFailure, List<Course>>> coursesOption,
    required Option<Either<AppFailure, Resume>> resumeOption,
  }) = _ContentState;

  /// Initial state before any public content has been requested.
  factory ContentState.initial() => ContentState(
    status: ContentStatus.initial,
    failureOption: none(),
    aboutOption: none(),
    projectsOption: none(),
    caseStudiesOption: none(),
    certificationsOption: none(),
    coursesOption: none(),
    resumeOption: none(),
  );
}
