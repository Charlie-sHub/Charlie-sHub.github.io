import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/content/content_repository_interface.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_theme.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildPresentationTestApp(
  Widget child, {
  double width = 960,
}) => MaterialApp(
  theme: buildAppTheme(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: width,
          child: child,
        ),
      ),
    ),
  ),
);

Future<TestContentCubit> pumpWithContentState(
  WidgetTester tester, {
  required Widget child,
  required ContentState state,
  double width = 960,
}) async {
  final cubit = TestContentCubit()..emitState(state);
  addTearDown(cubit.close);

  await tester.pumpWidget(
    BlocProvider<ContentCubit>.value(
      value: cubit,
      child: buildPresentationTestApp(
        child,
        width: width,
      ),
    ),
  );
  await tester.pump();

  return cubit;
}

class TestContentCubit extends ContentCubit {
  TestContentCubit() : super(_NoopContentRepository());

  void emitState(ContentState state) => emit(state);
}

class _NoopContentRepository implements ContentRepositoryInterface {
  @override
  Future<Either<AppFailure, About>> loadAbout() => throw UnimplementedError();

  @override
  Future<MultiEntrySectionLoad<CaseStudy>> loadCaseStudies() =>
      throw UnimplementedError();

  @override
  Future<MultiEntrySectionLoad<Certification>> loadCertifications() =>
      throw UnimplementedError();

  @override
  Future<MultiEntrySectionLoad<Course>> loadCourses() =>
      throw UnimplementedError();

  @override
  Future<MultiEntrySectionLoad<Project>> loadProjects() =>
      throw UnimplementedError();

  @override
  Future<Either<AppFailure, Resume>> loadResume() => throw UnimplementedError();
}
