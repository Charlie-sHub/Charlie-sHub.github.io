import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_repository_interface.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Orchestrates loading the portfolio's public content sections.
class ContentCubit extends Cubit<ContentState> {
  /// Creates a content Cubit backed by the given repository interface.
  ContentCubit(this._contentRepository) : super(ContentState.initial());

  final ContentRepositoryInterface _contentRepository;

  /// Loads every public content section in parallel and emits section updates
  /// as each result becomes available.
  Future<void> loadAllContent() async {
    emit(
      ContentState.initial().copyWith(
        status: ContentStatus.loading,
        failureOption: none(),
      ),
    );

    try {
      await Future.wait<void>(
        <Future<void>>[
          _loadAbout(),
          _loadProjects(),
          _loadCaseStudies(),
          _loadCertifications(),
          _loadCourses(),
          _loadResume(),
        ],
      );

      if (isClosed) {
        return;
      } else {
        emit(
          state.copyWith(
            status: ContentStatus.loaded,
            failureOption: none(),
          ),
        );
      }
    } on Object catch (error) {
      final orchestrationFailure = error is AppFailure
          ? error
          : AppFailure.unexpectedError(
              errorString: error.toString(),
            );

      if (isClosed) {
        return;
      } else {
        emit(
          state.copyWith(
            status: ContentStatus.failure,
            failureOption: some(orchestrationFailure),
          ),
        );
      }
    }
  }

  Future<void> _loadAbout() async {
    final aboutResult = await _contentRepository.loadAbout();

    if (isClosed) {
      return;
    } else {
      emit(
        state.copyWith(
          aboutOption: some(aboutResult),
        ),
      );
    }
  }

  Future<void> _loadProjects() async {
    final projectsResult = await _contentRepository.loadProjects();

    if (isClosed) {
      return;
    } else {
      emit(
        state.copyWith(
          projectsOption: some(projectsResult),
        ),
      );
    }
  }

  Future<void> _loadCaseStudies() async {
    final caseStudiesResult = await _contentRepository.loadCaseStudies();

    if (isClosed) {
      return;
    } else {
      emit(
        state.copyWith(
          caseStudiesOption: some(caseStudiesResult),
        ),
      );
    }
  }

  Future<void> _loadCertifications() async {
    final certificationsResult = await _contentRepository.loadCertifications();

    if (isClosed) {
      return;
    } else {
      emit(
        state.copyWith(
          certificationsOption: some(certificationsResult),
        ),
      );
    }
  }

  Future<void> _loadCourses() async {
    final coursesResult = await _contentRepository.loadCourses();

    if (isClosed) {
      return;
    } else {
      emit(
        state.copyWith(
          coursesOption: some(coursesResult),
        ),
      );
    }
  }

  Future<void> _loadResume() async {
    final resumeResult = await _contentRepository.loadResume();

    if (isClosed) {
      return;
    } else {
      emit(
        state.copyWith(
          resumeOption: some(resumeResult),
        ),
      );
    }
  }
}
