import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/content/content_repository_interface.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
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
          _verifyAllLoadMethodsCalled(contentRepository, times: 1);
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
          _projects = _successfulItems<Project>(<Project>[buildProject()]);
          _caseStudies = _successfulItems<CaseStudy>(<CaseStudy>[
            buildCaseStudy(),
          ]);
          _certifications = _successfulItems<Certification>(<Certification>[
            buildCertification(),
          ]);
          _courses = _successfulItems<Course>(<Course>[buildCourse()]);
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
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            caseStudiesOption: some(
              _sectionLoadSuccess<CaseStudy>(_caseStudies),
            ),
            certificationsOption: some(
              _sectionLoadSuccess<Certification>(_certifications),
            ),
            coursesOption: some(_sectionLoadSuccess<Course>(_courses)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
        ],
        verify: (_) {
          _verifyAllLoadMethodsCalled(contentRepository, times: 1);
        },
      );

      blocTest<ContentCubit, ContentState>(
        'mixed local failures stay local and the final status is still loaded',
        build: () {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          _about = buildAbout();
          _projects = _successfulItems<Project>(<Project>[buildProject()]);
          _caseStudies = _successfulItems<CaseStudy>(<CaseStudy>[
            buildCaseStudy(),
          ]);
          _certifications = _successfulItems<Certification>(<Certification>[
            buildCertification(),
          ]);
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
            _sectionLoadFailure<Course>(_coursesFailure),
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
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            caseStudiesOption: some(
              _sectionLoadSuccess<CaseStudy>(_caseStudies),
            ),
            certificationsOption: some(
              _sectionLoadSuccess<Certification>(_certifications),
            ),
            coursesOption: some(_sectionLoadFailure<Course>(_coursesFailure)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
        ],
      );

      blocTest<ContentCubit, ContentState>(
        'orchestration-level failure sets the top-level status to failure',
        build: () {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          _about = buildAbout();
          _projects = _successfulItems<Project>(<Project>[buildProject()]);
          _caseStudies = _successfulItems<CaseStudy>(<CaseStudy>[
            buildCaseStudy(),
          ]);
          _certifications = _successfulItems<Certification>(<Certification>[
            buildCertification(),
          ]);
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
          _projects = _successfulItems<Project>(<Project>[buildProject()]);
          _caseStudies = _successfulItems<CaseStudy>(<CaseStudy>[
            buildCaseStudy(),
          ]);
          _certifications = _successfulItems<Certification>(<Certification>[
            buildCertification(),
          ]);
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
          _verifyAllLoadMethodsCalled(contentRepository, times: 1);

          _pendingContentLoads.projectsCompleter.complete(right(_projects));
          await _nextAsyncTurn();

          _pendingContentLoads.resumeCompleter.complete(right(_resume));
          await _nextAsyncTurn();

          _pendingContentLoads.coursesCompleter.complete(
            _sectionLoadFailure<Course>(_coursesFailure),
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
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
          ),
          _loadingState(
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
          _loadingState(
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            coursesOption: some(_sectionLoadFailure<Course>(_coursesFailure)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            coursesOption: some(_sectionLoadFailure<Course>(_coursesFailure)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            certificationsOption: some(
              _sectionLoadSuccess<Certification>(_certifications),
            ),
            coursesOption: some(_sectionLoadFailure<Course>(_coursesFailure)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            caseStudiesOption: some(
              _sectionLoadSuccess<CaseStudy>(_caseStudies),
            ),
            certificationsOption: some(
              _sectionLoadSuccess<Certification>(_certifications),
            ),
            coursesOption: some(_sectionLoadFailure<Course>(_coursesFailure)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
          _loadedState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            caseStudiesOption: some(
              _sectionLoadSuccess<CaseStudy>(_caseStudies),
            ),
            certificationsOption: some(
              _sectionLoadSuccess<Certification>(_certifications),
            ),
            coursesOption: some(_sectionLoadFailure<Course>(_coursesFailure)),
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
            _sectionLoadSuccess<Project>(
              _successfulItems<Project>(<Project>[buildProject()]),
            ),
          ),
          caseStudiesOption: some(
            _sectionLoadSuccess<CaseStudy>(
              _successfulItems<CaseStudy>(<CaseStudy>[buildCaseStudy()]),
            ),
          ),
          certificationsOption: some(
            _sectionLoadSuccess<Certification>(
              _successfulItems<Certification>(<Certification>[
                buildCertification(),
              ]),
            ),
          ),
          coursesOption: some(
            _sectionLoadSuccess<Course>(
              _successfulItems<Course>(<Course>[buildCourse()]),
            ),
          ),
          resumeOption: some(right<AppFailure, Resume>(buildResume())),
        ),
        build: () {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          _about = buildAbout();
          _projects = _successfulItems<Project>(<Project>[buildProject()]);
          _caseStudies = _successfulItems<CaseStudy>(<CaseStudy>[
            buildCaseStudy(),
          ]);
          _certifications = _successfulItems<Certification>(<Certification>[
            buildCertification(),
          ]);
          _courses = _successfulItems<Course>(<Course>[buildCourse()]);
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
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            caseStudiesOption: some(
              _sectionLoadSuccess<CaseStudy>(_caseStudies),
            ),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            caseStudiesOption: some(
              _sectionLoadSuccess<CaseStudy>(_caseStudies),
            ),
            certificationsOption: some(
              _sectionLoadSuccess<Certification>(_certifications),
            ),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            caseStudiesOption: some(
              _sectionLoadSuccess<CaseStudy>(_caseStudies),
            ),
            certificationsOption: some(
              _sectionLoadSuccess<Certification>(_certifications),
            ),
            coursesOption: some(_sectionLoadSuccess<Course>(_courses)),
          ),
          _loadingState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            caseStudiesOption: some(
              _sectionLoadSuccess<CaseStudy>(_caseStudies),
            ),
            certificationsOption: some(
              _sectionLoadSuccess<Certification>(_certifications),
            ),
            coursesOption: some(_sectionLoadSuccess<Course>(_courses)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
          _loadedState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            caseStudiesOption: some(
              _sectionLoadSuccess<CaseStudy>(_caseStudies),
            ),
            certificationsOption: some(
              _sectionLoadSuccess<Certification>(_certifications),
            ),
            coursesOption: some(_sectionLoadSuccess<Course>(_courses)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
        ],
      );

      blocTest<ContentCubit, ContentState>(
        'domain-invalid but successful content remains Right in state',
        build: () {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          _invalidAbout = buildInvalidAbout();
          _projects = _successfulItems<Project>(<Project>[buildProject()]);
          _caseStudies = _successfulItems<CaseStudy>(<CaseStudy>[
            buildCaseStudy(),
          ]);
          _certifications = _successfulItems<Certification>(<Certification>[
            buildCertification(),
          ]);
          _courses = _successfulItems<Course>(<Course>[buildCourse()]);
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
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            caseStudiesOption: some(
              _sectionLoadSuccess<CaseStudy>(_caseStudies),
            ),
            certificationsOption: some(
              _sectionLoadSuccess<Certification>(_certifications),
            ),
            coursesOption: some(_sectionLoadSuccess<Course>(_courses)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
        ],
      );

      blocTest<ContentCubit, ContentState>(
        'item-level project load failures stay inside a successful section '
        'state result',
        build: () {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          _about = buildAbout();
          _projects = <SectionItemLoad<Project>>[
            left<AppFailure, Project>(
              const AppFailure.contentLoadError(
                path: 'assets/content/projects/pami.json',
                errorString: 'Invalid project payload',
              ),
            ),
            right<AppFailure, Project>(buildProject()),
          ];
          _caseStudies = _successfulItems<CaseStudy>(<CaseStudy>[
            buildCaseStudy(),
          ]);
          _certifications = _successfulItems<Certification>(<Certification>[
            buildCertification(),
          ]);
          _courses = _successfulItems<Course>(<Course>[buildCourse()]);
          _resume = buildResume();
          _pendingContentLoads = pendingLoads;
          return ContentCubit(contentRepository);
        },
        act: (cubit) async {
          final loadFuture = cubit.loadAllContent();
          await _nextAsyncTurn();
          _pendingContentLoads.aboutCompleter.complete(right(_about));
          await _nextAsyncTurn();
          _pendingContentLoads.projectsCompleter.complete(
            _sectionLoadSuccess<Project>(_projects),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.caseStudiesCompleter.complete(
            _sectionLoadSuccess<CaseStudy>(_caseStudies),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.certificationsCompleter.complete(
            _sectionLoadSuccess<Certification>(_certifications),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.coursesCompleter.complete(
            _sectionLoadSuccess<Course>(_courses),
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
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            caseStudiesOption: some(
              _sectionLoadSuccess<CaseStudy>(_caseStudies),
            ),
            certificationsOption: some(
              _sectionLoadSuccess<Certification>(_certifications),
            ),
            coursesOption: some(_sectionLoadSuccess<Course>(_courses)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
        ],
      );

      blocTest<ContentCubit, ContentState>(
        'an invalid optional project field remains a successful item result in '
        'state',
        build: () {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          final invalidProject = buildProject().copyWith(
            thumbnailPath: AssetPath('assets/documents/not-a-media-path.pdf'),
          );
          _about = buildAbout();
          _projects = <SectionItemLoad<Project>>[
            right<AppFailure, Project>(invalidProject),
            right<AppFailure, Project>(buildProject()),
          ];
          _caseStudies = _successfulItems<CaseStudy>(<CaseStudy>[
            buildCaseStudy(),
          ]);
          _certifications = _successfulItems<Certification>(<Certification>[
            buildCertification(),
          ]);
          _courses = _successfulItems<Course>(<Course>[buildCourse()]);
          _resume = buildResume();
          _pendingContentLoads = pendingLoads;
          return ContentCubit(contentRepository);
        },
        act: (cubit) async {
          final loadFuture = cubit.loadAllContent();
          await _nextAsyncTurn();
          _pendingContentLoads.aboutCompleter.complete(right(_about));
          await _nextAsyncTurn();
          _pendingContentLoads.projectsCompleter.complete(
            _sectionLoadSuccess<Project>(_projects),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.caseStudiesCompleter.complete(
            _sectionLoadSuccess<CaseStudy>(_caseStudies),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.certificationsCompleter.complete(
            _sectionLoadSuccess<Certification>(_certifications),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.coursesCompleter.complete(
            _sectionLoadSuccess<Course>(_courses),
          );
          await _nextAsyncTurn();
          _pendingContentLoads.resumeCompleter.complete(right(_resume));
          await loadFuture;
          await _nextAsyncTurn();
        },
        verify: (_) {
          final firstProject = _expectRightItem(_projects.first);
          expect(firstProject.isValid, isFalse);
        },
        skip: 7,
        expect: () => <ContentState>[
          _loadedState(
            aboutOption: some(right<AppFailure, About>(_about)),
            projectsOption: some(_sectionLoadSuccess<Project>(_projects)),
            caseStudiesOption: some(
              _sectionLoadSuccess<CaseStudy>(_caseStudies),
            ),
            certificationsOption: some(
              _sectionLoadSuccess<Certification>(_certifications),
            ),
            coursesOption: some(_sectionLoadSuccess<Course>(_courses)),
            resumeOption: some(right<AppFailure, Resume>(_resume)),
          ),
        ],
      );

      test(
        'concurrent loadAllContent calls reuse the same in-flight load',
        () async {
          final pendingLoads = _stubPendingContentLoads(contentRepository);
          final cubit = ContentCubit(contentRepository);
          final emittedStates = <ContentState>[];
          final subscription = cubit.stream.listen(emittedStates.add);
          final about = buildAbout();
          final projects = _successfulItems<Project>(<Project>[buildProject()]);
          final caseStudies = _successfulItems<CaseStudy>(<CaseStudy>[
            buildCaseStudy(),
          ]);
          final certifications = _successfulItems<Certification>(
            <Certification>[
              buildCertification(),
            ],
          );
          final courses = _successfulItems<Course>(<Course>[buildCourse()]);
          final resume = buildResume();

          final firstLoad = cubit.loadAllContent();
          await _nextAsyncTurn();
          final secondLoad = cubit.loadAllContent();
          await _nextAsyncTurn();

          expect(identical(firstLoad, secondLoad), isTrue);
          expect(emittedStates, <ContentState>[_loadingState()]);
          _verifyAllLoadMethodsCalled(contentRepository, times: 1);

          pendingLoads.aboutCompleter.complete(right(about));
          await _nextAsyncTurn();
          pendingLoads.projectsCompleter.complete(right(projects));
          await _nextAsyncTurn();
          pendingLoads.caseStudiesCompleter.complete(right(caseStudies));
          await _nextAsyncTurn();
          pendingLoads.certificationsCompleter.complete(right(certifications));
          await _nextAsyncTurn();
          pendingLoads.coursesCompleter.complete(right(courses));
          await _nextAsyncTurn();
          pendingLoads.resumeCompleter.complete(right(resume));
          await Future.wait<void>(<Future<void>>[
            firstLoad,
            secondLoad,
          ]);
          await _nextAsyncTurn();

          expect(cubit.state.status, ContentStatus.loaded);
          await subscription.cancel();
          await cubit.close();
        },
      );

      test(
        'a later loadAllContent call starts fresh work after the first load '
        'completes',
        () async {
          final firstPendingLoads = _PendingContentLoads();
          final secondPendingLoads = _PendingContentLoads();
          final firstAbout = buildAbout().copyWith(title: Title('First About'));
          final secondAbout = buildAbout().copyWith(
            title: Title('Second About'),
          );
          final firstProjects = _successfulItems<Project>(<Project>[
            buildProject().copyWith(title: Title('First Project')),
          ]);
          final secondProjects = _successfulItems<Project>(<Project>[
            buildProject().copyWith(title: Title('Second Project')),
          ]);
          final cubit = ContentCubit(contentRepository);
          final emittedStates = <ContentState>[];
          final subscription = cubit.stream.listen(emittedStates.add);

          _stubSequentialContentLoads(
            contentRepository,
            <_PendingContentLoads>[
              firstPendingLoads,
              secondPendingLoads,
            ],
          );

          final firstLoad = cubit.loadAllContent();
          await _nextAsyncTurn();
          firstPendingLoads.aboutCompleter.complete(right(firstAbout));
          firstPendingLoads.projectsCompleter.complete(
            _sectionLoadSuccess<Project>(firstProjects),
          );
          firstPendingLoads.caseStudiesCompleter.complete(
            _sectionLoadSuccess<CaseStudy>(
              _successfulItems<CaseStudy>(<CaseStudy>[buildCaseStudy()]),
            ),
          );
          firstPendingLoads.certificationsCompleter.complete(
            _sectionLoadSuccess<Certification>(
              _successfulItems<Certification>(<Certification>[
                buildCertification(),
              ]),
            ),
          );
          firstPendingLoads.coursesCompleter.complete(
            _sectionLoadSuccess<Course>(
              _successfulItems<Course>(<Course>[buildCourse()]),
            ),
          );
          firstPendingLoads.resumeCompleter.complete(right(buildResume()));
          await firstLoad;
          await _nextAsyncTurn();

          final secondLoad = cubit.loadAllContent();
          await _nextAsyncTurn();

          secondPendingLoads.aboutCompleter.complete(right(secondAbout));
          secondPendingLoads.projectsCompleter.complete(
            _sectionLoadSuccess<Project>(secondProjects),
          );
          secondPendingLoads.caseStudiesCompleter.complete(
            _sectionLoadSuccess<CaseStudy>(
              _successfulItems<CaseStudy>(<CaseStudy>[buildCaseStudy()]),
            ),
          );
          secondPendingLoads.certificationsCompleter.complete(
            _sectionLoadSuccess<Certification>(
              _successfulItems<Certification>(<Certification>[
                buildCertification(),
              ]),
            ),
          );
          secondPendingLoads.coursesCompleter.complete(
            _sectionLoadSuccess<Course>(
              _successfulItems<Course>(<Course>[buildCourse()]),
            ),
          );
          secondPendingLoads.resumeCompleter.complete(right(buildResume()));
          await secondLoad;
          await _nextAsyncTurn();

          final finalState = emittedStates.last;
          final loadedAbout = _expectRight(_expectSome(finalState.aboutOption));
          final loadedProjects = _expectRight(
            _expectSome(finalState.projectsOption),
          );

          expect(finalState.status, ContentStatus.loaded);
          expect(
            emittedStates.where(
              (state) => state == _loadingState(),
            ),
            hasLength(2),
          );
          expect(loadedAbout.title.getOrCrash(), 'Second About');
          expect(
            _expectRightItem(loadedProjects.first).title.getOrCrash(),
            'Second Project',
          );

          _verifyAllLoadMethodsCalled(contentRepository, times: 2);
          await subscription.cancel();
          await cubit.close();
        },
      );
    },
  );
}

late _PendingContentLoads _pendingContentLoads;
late About _about;
late About _invalidAbout;
late List<SectionItemLoad<Project>> _projects;
late List<SectionItemLoad<CaseStudy>> _caseStudies;
late List<SectionItemLoad<Certification>> _certifications;
late List<SectionItemLoad<Course>> _courses;
late Resume _resume;
late AppFailure _coursesFailure;

final class _PendingContentLoads {
  final aboutCompleter = Completer<Either<AppFailure, About>>();
  final projectsCompleter = Completer<MultiEntrySectionLoad<Project>>();
  final caseStudiesCompleter = Completer<MultiEntrySectionLoad<CaseStudy>>();
  final certificationsCompleter =
      Completer<MultiEntrySectionLoad<Certification>>();
  final coursesCompleter = Completer<MultiEntrySectionLoad<Course>>();
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

void _stubSequentialContentLoads(
  MockContentRepository contentRepository,
  List<_PendingContentLoads> pendingLoadsByCall,
) {
  var aboutCallCount = 0;
  var projectsCallCount = 0;
  var caseStudiesCallCount = 0;
  var certificationsCallCount = 0;
  var coursesCallCount = 0;
  var resumeCallCount = 0;

  when(contentRepository.loadAbout()).thenAnswer(
    (_) => pendingLoadsByCall[aboutCallCount++].aboutCompleter.future,
  );
  when(contentRepository.loadProjects()).thenAnswer(
    (_) => pendingLoadsByCall[projectsCallCount++].projectsCompleter.future,
  );
  when(contentRepository.loadCaseStudies()).thenAnswer(
    (_) =>
        pendingLoadsByCall[caseStudiesCallCount++].caseStudiesCompleter.future,
  );
  when(contentRepository.loadCertifications()).thenAnswer(
    (_) => pendingLoadsByCall[certificationsCallCount++]
        .certificationsCompleter
        .future,
  );
  when(contentRepository.loadCourses()).thenAnswer(
    (_) => pendingLoadsByCall[coursesCallCount++].coursesCompleter.future,
  );
  when(contentRepository.loadResume()).thenAnswer(
    (_) => pendingLoadsByCall[resumeCallCount++].resumeCompleter.future,
  );
}

void _verifyAllLoadMethodsCalled(
  MockContentRepository contentRepository, {
  required int times,
}) {
  verify(contentRepository.loadAbout()).called(times);
  verify(contentRepository.loadProjects()).called(times);
  verify(contentRepository.loadCaseStudies()).called(times);
  verify(contentRepository.loadCertifications()).called(times);
  verify(contentRepository.loadCourses()).called(times);
  verify(contentRepository.loadResume()).called(times);
}

Future<void> _nextAsyncTurn() => Future<void>.delayed(Duration.zero);

ContentState _loadingState({
  Option<AppFailure>? failureOption,
  Option<Either<AppFailure, About>>? aboutOption,
  Option<MultiEntrySectionLoad<Project>>? projectsOption,
  Option<MultiEntrySectionLoad<CaseStudy>>? caseStudiesOption,
  Option<MultiEntrySectionLoad<Certification>>? certificationsOption,
  Option<MultiEntrySectionLoad<Course>>? coursesOption,
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
  Option<MultiEntrySectionLoad<Project>>? projectsOption,
  Option<MultiEntrySectionLoad<CaseStudy>>? caseStudiesOption,
  Option<MultiEntrySectionLoad<Certification>>? certificationsOption,
  Option<MultiEntrySectionLoad<Course>>? coursesOption,
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

List<SectionItemLoad<T>> _successfulItems<T>(List<T> values) =>
    values.map((value) => right<AppFailure, T>(value)).toList(growable: false);

T _expectSome<T>(Option<T> option) =>
    option.getOrElse(() => throw StateError('Expected a populated option.'));

T _expectRight<T>(Either<AppFailure, T> result) => result.fold(
  (failure) => throw StateError('$failure'),
  (value) => value,
);

T _expectRightItem<T>(SectionItemLoad<T> result) => result.fold(
  (failure) => throw StateError('$failure'),
  (value) => value,
);

MultiEntrySectionLoad<T> _sectionLoadSuccess<T>(
  List<SectionItemLoad<T>> itemResults,
) => right<AppFailure, List<SectionItemLoad<T>>>(itemResults);

MultiEntrySectionLoad<T> _sectionLoadFailure<T>(AppFailure failure) =>
    left<AppFailure, List<SectionItemLoad<T>>>(failure);
