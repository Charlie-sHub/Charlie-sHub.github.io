import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_repository_interface.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<ContentRepositoryInterface>(as: #MockContentRepository),
])
import 'content_cubit_test.mocks.dart';
import 'content_test_entity_builders.dart';

void main() {
  late MockContentRepository contentRepository;

  setUp(() {
    contentRepository = MockContentRepository();
  });

  group(
    'ContentCubit',
    () {
      test(
        'initial state is correct',
        () async {
          final cubit = ContentCubit(contentRepository);

          expect(cubit.state.status, ContentStatus.initial);
          expect(cubit.state.failureOption.isNone(), isTrue);
          expect(cubit.state.aboutOption.isNone(), isTrue);
          expect(cubit.state.projectsOption.isNone(), isTrue);
          expect(cubit.state.caseStudiesOption.isNone(), isTrue);
          expect(cubit.state.certificationsOption.isNone(), isTrue);
          expect(cubit.state.coursesOption.isNone(), isTrue);
          expect(cubit.state.resumeOption.isNone(), isTrue);

          await cubit.close();
        },
      );

      blocTest<ContentCubit, ContentState>(
        'loadAllContent emits loading first and resets section fields to none',
        build: () {
          _stubPendingContentLoads(contentRepository);
          return ContentCubit(contentRepository);
        },
        act: (cubit) async {
          unawaited(cubit.loadAllContent());
          await _nextAsyncTurn();
          _verifyAllLoadMethodsCalled(contentRepository);
        },
        expect: () => <ContentState>[
          _loadingState(),
        ],
      );

      blocTest<ContentCubit, ContentState>(
        'all-success path finishes loaded with every section as some(Right)',
        build: () {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          _about = buildAbout();
          _projects = <Project>[buildProject()];
          _caseStudies = <CaseStudy>[buildCaseStudy()];
          _certifications = <Certification>[buildCertification()];
          _courses = <Course>[buildCourse()];
          _resume = buildResume();
          _pendingContentLoads = pendingLoads;
          return ContentCubit(contentRepository);
        },
        act: (cubit) async {
          final loadFuture = cubit.loadAllContent();
          await _nextAsyncTurn();
          _pendingContentLoads.aboutCompleter.complete(right(_about));
          await _nextAsyncTurn();
          _pendingContentLoads.projectsCompleter.complete(right(_projects));
          await _nextAsyncTurn();
          _pendingContentLoads.caseStudiesCompleter.complete(
            right(_caseStudies),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.certificationsCompleter.complete(
            right(_certifications),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.coursesCompleter.complete(right(_courses));
          await _nextAsyncTurn();
          _pendingContentLoads.resumeCompleter.complete(right(_resume));
          await loadFuture;
          await _nextAsyncTurn();
        },
        skip: 7,
        expect: () => <ContentState>[
          _loadedState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            caseStudiesOption: some(
              right<AppFailure, List<CaseStudy>>(_caseStudies),
            ),
            certificationsOption: some(
              right<AppFailure, List<Certification>>(_certifications),
            ),
            coursesOption: some(right<AppFailure, List<Course>>(_courses)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
        ],
        verify: (_) {
          _verifyAllLoadMethodsCalled(contentRepository);
        },
      );

      blocTest<ContentCubit, ContentState>(
        'mixed local failures stay local and the final status is still loaded',
        build: () {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          _about = buildAbout();
          _projects = <Project>[buildProject()];
          _caseStudies = <CaseStudy>[buildCaseStudy()];
          _certifications = <Certification>[buildCertification()];
          _coursesFailure = const AppFailure.assetNotFound(
            path: 'assets/content/courses/index.json',
          );
          _resume = buildResume();
          _pendingContentLoads = pendingLoads;
          return ContentCubit(contentRepository);
        },
        act: (cubit) async {
          final loadFuture = cubit.loadAllContent();
          await _nextAsyncTurn();
          _pendingContentLoads.aboutCompleter.complete(right(_about));
          await _nextAsyncTurn();
          _pendingContentLoads.projectsCompleter.complete(right(_projects));
          await _nextAsyncTurn();
          _pendingContentLoads.caseStudiesCompleter.complete(
            right(_caseStudies),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.certificationsCompleter.complete(
            right(_certifications),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.coursesCompleter.complete(
            left<AppFailure, List<Course>>(_coursesFailure),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.resumeCompleter.complete(right(_resume));
          await loadFuture;
          await _nextAsyncTurn();
        },
        skip: 7,
        expect: () => <ContentState>[
          _loadedState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            caseStudiesOption: some(
              right<AppFailure, List<CaseStudy>>(_caseStudies),
            ),
            certificationsOption: some(
              right<AppFailure, List<Certification>>(_certifications),
            ),
            coursesOption: some(
              left<AppFailure, List<Course>>(_coursesFailure),
            ),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
        ],
      );

      blocTest<ContentCubit, ContentState>(
        'orchestration-level failure sets the top-level status to failure',
        build: () {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          _about = buildAbout();
          _projects = <Project>[buildProject()];
          _caseStudies = <CaseStudy>[buildCaseStudy()];
          _certifications = <Certification>[buildCertification()];
          _resume = buildResume();
          _pendingContentLoads = pendingLoads;
          when(contentRepository.loadCourses()).thenThrow(StateError('boom'));
          return ContentCubit(contentRepository);
        },
        act: (cubit) async {
          final loadFuture = cubit.loadAllContent();
          await _nextAsyncTurn();
          _pendingContentLoads.aboutCompleter.complete(right(_about));
          await _nextAsyncTurn();
          _pendingContentLoads.projectsCompleter.complete(right(_projects));
          await _nextAsyncTurn();
          _pendingContentLoads.caseStudiesCompleter.complete(
            right(_caseStudies),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.certificationsCompleter.complete(
            right(_certifications),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.resumeCompleter.complete(right(_resume));
          await loadFuture;
          await _nextAsyncTurn();
        },
        skip: 6,
        expect: () => <Matcher>[
          isA<ContentState>()
              .having(
                (state) => state.status,
                'status',
                ContentStatus.failure,
              )
              .having(
                (state) => state.failureOption,
                'failureOption',
                some(
                  const AppFailure.unexpectedError(
                    errorString: 'Bad state: boom',
                  ),
                ),
              )
              .having(
                (state) => state.coursesOption.isNone(),
                'coursesOption.isNone()',
                isTrue,
              ),
        ],
      );

      blocTest<ContentCubit, ContentState>(
        'partial update behavior emits intermediate states as sections finish',
        build: () {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          _about = buildAbout();
          _projects = <Project>[buildProject()];
          _caseStudies = <CaseStudy>[buildCaseStudy()];
          _certifications = <Certification>[buildCertification()];
          _coursesFailure = const AppFailure.assetNotFound(
            path: 'assets/content/courses/index.json',
          );
          _resume = buildResume();
          _pendingContentLoads = pendingLoads;
          return ContentCubit(contentRepository);
        },
        act: (cubit) async {
          final loadFuture = cubit.loadAllContent();
          await _nextAsyncTurn();
          _verifyAllLoadMethodsCalled(contentRepository);

          _pendingContentLoads.projectsCompleter.complete(right(_projects));
          await _nextAsyncTurn();

          _pendingContentLoads.resumeCompleter.complete(right(_resume));
          await _nextAsyncTurn();

          _pendingContentLoads.coursesCompleter.complete(
            left<AppFailure, List<Course>>(_coursesFailure),
          );
          await _nextAsyncTurn();

          _pendingContentLoads.aboutCompleter.complete(right(_about));
          await _nextAsyncTurn();

          _pendingContentLoads.certificationsCompleter.complete(
            right(_certifications),
          );
          await _nextAsyncTurn();

          _pendingContentLoads.caseStudiesCompleter.complete(
            right(_caseStudies),
          );
          await loadFuture;
          await _nextAsyncTurn();
        },
        expect: () => <ContentState>[
          _loadingState(),
          _loadingState(
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
          ),
          _loadingState(
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
          _loadingState(
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            coursesOption: some(
              left<AppFailure, List<Course>>(_coursesFailure),
            ),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            coursesOption: some(
              left<AppFailure, List<Course>>(_coursesFailure),
            ),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            certificationsOption: some(
              right<AppFailure, List<Certification>>(_certifications),
            ),
            coursesOption: some(
              left<AppFailure, List<Course>>(_coursesFailure),
            ),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            caseStudiesOption: some(
              right<AppFailure, List<CaseStudy>>(_caseStudies),
            ),
            certificationsOption: some(
              right<AppFailure, List<Certification>>(_certifications),
            ),
            coursesOption: some(
              left<AppFailure, List<Course>>(_coursesFailure),
            ),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
          _loadedState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            caseStudiesOption: some(
              right<AppFailure, List<CaseStudy>>(_caseStudies),
            ),
            certificationsOption: some(
              right<AppFailure, List<Certification>>(_certifications),
            ),
            coursesOption: some(
              left<AppFailure, List<Course>>(_coursesFailure),
            ),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
        ],
      );

      blocTest<ContentCubit, ContentState>(
        'calling loadAllContent again emits loading and clears prior results',
        seed: () => _loadedState(
          failureOption: some(
            const AppFailure.unexpectedError(
              errorString: 'stale failure',
            ),
          ),
          aboutOption: some(right<AppFailure, About>(buildAbout())),
          projectsOption: some(
            right<AppFailure, List<Project>>(<Project>[buildProject()]),
          ),
          caseStudiesOption: some(
            right<AppFailure, List<CaseStudy>>(<CaseStudy>[buildCaseStudy()]),
          ),
          certificationsOption: some(
            right<AppFailure, List<Certification>>(
              <Certification>[buildCertification()],
            ),
          ),
          coursesOption: some(
            right<AppFailure, List<Course>>(<Course>[buildCourse()]),
          ),
          resumeOption: some(right<AppFailure, Resume>(buildResume())),
        ),
        build: () {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          _about = buildAbout();
          _projects = <Project>[buildProject()];
          _caseStudies = <CaseStudy>[buildCaseStudy()];
          _certifications = <Certification>[buildCertification()];
          _courses = <Course>[buildCourse()];
          _resume = buildResume();
          _pendingContentLoads = pendingLoads;
          return ContentCubit(contentRepository);
        },
        act: (cubit) async {
          final loadFuture = cubit.loadAllContent();
          await _nextAsyncTurn();
          _pendingContentLoads.aboutCompleter.complete(right(_about));
          await _nextAsyncTurn();
          _pendingContentLoads.projectsCompleter.complete(right(_projects));
          await _nextAsyncTurn();
          _pendingContentLoads.caseStudiesCompleter.complete(
            right(_caseStudies),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.certificationsCompleter.complete(
            right(_certifications),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.coursesCompleter.complete(right(_courses));
          await _nextAsyncTurn();
          _pendingContentLoads.resumeCompleter.complete(right(_resume));
          await loadFuture;
          await _nextAsyncTurn();
        },
        expect: () => <ContentState>[
          _loadingState(),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            caseStudiesOption: some(
              right<AppFailure, List<CaseStudy>>(_caseStudies),
            ),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            caseStudiesOption: some(
              right<AppFailure, List<CaseStudy>>(_caseStudies),
            ),
            certificationsOption: some(
              right<AppFailure, List<Certification>>(_certifications),
            ),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            caseStudiesOption: some(
              right<AppFailure, List<CaseStudy>>(_caseStudies),
            ),
            certificationsOption: some(
              right<AppFailure, List<Certification>>(_certifications),
            ),
            coursesOption: some(right<AppFailure, List<Course>>(_courses)),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            caseStudiesOption: some(
              right<AppFailure, List<CaseStudy>>(_caseStudies),
            ),
            certificationsOption: some(
              right<AppFailure, List<Certification>>(_certifications),
            ),
            coursesOption: some(right<AppFailure, List<Course>>(_courses)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
          _loadedState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            caseStudiesOption: some(
              right<AppFailure, List<CaseStudy>>(_caseStudies),
            ),
            certificationsOption: some(
              right<AppFailure, List<Certification>>(_certifications),
            ),
            coursesOption: some(right<AppFailure, List<Course>>(_courses)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
        ],
      );

      blocTest<ContentCubit, ContentState>(
        'domain-invalid but successful content remains Right in state',
        build: () {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          _invalidAbout = buildInvalidAbout();
          _projects = <Project>[buildProject()];
          _caseStudies = <CaseStudy>[buildCaseStudy()];
          _certifications = <Certification>[buildCertification()];
          _courses = <Course>[buildCourse()];
          _resume = buildResume();
          _pendingContentLoads = pendingLoads;
          return ContentCubit(contentRepository);
        },
        act: (cubit) async {
          expect(_invalidAbout.failureOption.isSome(), isTrue);

          final loadFuture = cubit.loadAllContent();
          await _nextAsyncTurn();
          _pendingContentLoads.aboutCompleter.complete(right(_invalidAbout));
          await _nextAsyncTurn();
          _pendingContentLoads.projectsCompleter.complete(right(_projects));
          await _nextAsyncTurn();
          _pendingContentLoads.caseStudiesCompleter.complete(
            right(_caseStudies),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.certificationsCompleter.complete(
            right(_certifications),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.coursesCompleter.complete(right(_courses));
          await _nextAsyncTurn();
          _pendingContentLoads.resumeCompleter.complete(right(_resume));
          await loadFuture;
          await _nextAsyncTurn();
        },
        skip: 7,
        expect: () => <ContentState>[
          _loadedState(
            aboutOption: some(right<AppFailure, About>(_invalidAbout)),
            projectsOption: some(right<AppFailure, List<Project>>(_projects)),
            caseStudiesOption: some(
              right<AppFailure, List<CaseStudy>>(_caseStudies),
            ),
            certificationsOption: some(
              right<AppFailure, List<Certification>>(_certifications),
            ),
            coursesOption: some(right<AppFailure, List<Course>>(_courses)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
        ],
      );
    },
  );
}

late _PendingContentLoads _pendingContentLoads;
late About _about;
late About _invalidAbout;
late List<Project> _projects;
late List<CaseStudy> _caseStudies;
late List<Certification> _certifications;
late List<Course> _courses;
late Resume _resume;
late AppFailure _coursesFailure;

final class _PendingContentLoads {
  final aboutCompleter = Completer<Either<AppFailure, About>>();
  final projectsCompleter = Completer<Either<AppFailure, List<Project>>>();
  final caseStudiesCompleter = Completer<Either<AppFailure, List<CaseStudy>>>();
  final certificationsCompleter =
      Completer<Either<AppFailure, List<Certification>>>();
  final coursesCompleter = Completer<Either<AppFailure, List<Course>>>();
  final resumeCompleter = Completer<Either<AppFailure, Resume>>();
}

_PendingContentLoads _stubPendingContentLoads(
  MockContentRepository contentRepository,
) {
  final pendingLoads = _PendingContentLoads();

  when(contentRepository.loadAbout()).thenAnswer(
    (_) => pendingLoads.aboutCompleter.future,
  );
  when(contentRepository.loadProjects()).thenAnswer(
    (_) => pendingLoads.projectsCompleter.future,
  );
  when(contentRepository.loadCaseStudies()).thenAnswer(
    (_) => pendingLoads.caseStudiesCompleter.future,
  );
  when(contentRepository.loadCertifications()).thenAnswer(
    (_) => pendingLoads.certificationsCompleter.future,
  );
  when(contentRepository.loadCourses()).thenAnswer(
    (_) => pendingLoads.coursesCompleter.future,
  );
  when(contentRepository.loadResume()).thenAnswer(
    (_) => pendingLoads.resumeCompleter.future,
  );

  return pendingLoads;
}

void _verifyAllLoadMethodsCalled(
  MockContentRepository contentRepository,
) {
  verify(contentRepository.loadAbout()).called(1);
  verify(contentRepository.loadProjects()).called(1);
  verify(contentRepository.loadCaseStudies()).called(1);
  verify(contentRepository.loadCertifications()).called(1);
  verify(contentRepository.loadCourses()).called(1);
  verify(contentRepository.loadResume()).called(1);
}

Future<void> _nextAsyncTurn() => Future<void>.delayed(Duration.zero);

ContentState _loadingState({
  Option<AppFailure>? failureOption,
  Option<Either<AppFailure, About>>? aboutOption,
  Option<Either<AppFailure, List<Project>>>? projectsOption,
  Option<Either<AppFailure, List<CaseStudy>>>? caseStudiesOption,
  Option<Either<AppFailure, List<Certification>>>? certificationsOption,
  Option<Either<AppFailure, List<Course>>>? coursesOption,
  Option<Either<AppFailure, Resume>>? resumeOption,
}) => ContentState.initial().copyWith(
  status: ContentStatus.loading,
  failureOption: failureOption ?? none(),
  aboutOption: aboutOption ?? none(),
  projectsOption: projectsOption ?? none(),
  caseStudiesOption: caseStudiesOption ?? none(),
  certificationsOption: certificationsOption ?? none(),
  coursesOption: coursesOption ?? none(),
  resumeOption: resumeOption ?? none(),
);

ContentState _loadedState({
  Option<AppFailure>? failureOption,
  Option<Either<AppFailure, About>>? aboutOption,
  Option<Either<AppFailure, List<Project>>>? projectsOption,
  Option<Either<AppFailure, List<CaseStudy>>>? caseStudiesOption,
  Option<Either<AppFailure, List<Certification>>>? certificationsOption,
  Option<Either<AppFailure, List<Course>>>? coursesOption,
  Option<Either<AppFailure, Resume>>? resumeOption,
}) =>
    _loadingState(
      failureOption: failureOption,
      aboutOption: aboutOption,
      projectsOption: projectsOption,
      caseStudiesOption: caseStudiesOption,
      certificationsOption: certificationsOption,
      coursesOption: coursesOption,
      resumeOption: resumeOption,
    ).copyWith(
      status: ContentStatus.loaded,
    );
