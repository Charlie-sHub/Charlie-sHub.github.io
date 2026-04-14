import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart'
    as content_title;
import 'package:charlie_shub_portfolio/presentation/content/projects/projects_section.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_asset_media_card.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../application/content/content_test_entity_builders.dart';
import '../../core/presentation_test_helpers.dart';

void main() {
  group(
    'ProjectsSection',
    () {
      testWidgets(
        'shows loading state and then renders loaded project content',
        (tester) async {
          final cubit = await pumpWithContentState(
            tester,
            child: const ProjectsSection(),
            state: ContentState.initial().copyWith(
              status: ContentStatus.loading,
            ),
          );

          expect(find.text('Loading project content...'), findsOneWidget);

          cubit.emitState(
            _projectsState(
              right(<SectionItemLoad<Project>>[
                right(
                  buildProject().copyWith(
                    heroImagePath: AssetPath(
                      'assets/media/content/projects/pami/hero.png',
                    ),
                    endDate: null,
                  ),
                ),
              ]),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('Loading project content...'), findsNothing);
          expect(find.text('PAMi'), findsNWidgets(2));
          expect(find.text('A portfolio proof project.'), findsNWidgets(2));
          expect(find.text('View project details'), findsOneWidget);
          expect(find.text('Flutter'), findsNothing);
          expect(find.byType(AssetMediaCard), findsNothing);
          expect(find.byType(FieldFailureWidget), findsNothing);

          await tester.tap(find.text('View project details'));
          await tester.pump();

          expect(find.text('Hide project details'), findsOneWidget);
          expect(find.text('Flutter'), findsOneWidget);
          expect(find.byType(AssetMediaCard), findsOneWidget);
        },
      );

      testWidgets(
        'switches the selected project detail when another entry is chosen',
        (tester) async {
          final firstProject = buildProject();
          final secondProject = buildProject().copyWith(
            title: content_title.Title('Portfolio Shell'),
            summary: NonEmptyText('A second portfolio project.'),
          );

          await pumpWithContentState(
            tester,
            child: const ProjectsSection(),
            state: _projectsState(
              right(<SectionItemLoad<Project>>[
                right(firstProject),
                right(secondProject),
              ]),
            ),
          );

          expect(find.text('A portfolio proof project.'), findsNWidgets(2));
          expect(find.text('A second portfolio project.'), findsOneWidget);

          await tester.tap(
            find.byKey(const ValueKey<String>('entry-selector-item-1')),
          );
          await tester.pump();

          expect(find.text('A portfolio proof project.'), findsOneWidget);
          expect(find.text('A second portfolio project.'), findsNWidgets(2));
        },
      );

      testWidgets(
        'renders valid fields and failure widgets together for mixed content',
        (tester) async {
          final mixedProject = buildProject().copyWith(
            title: content_title.Title(''),
            heroImagePath: AssetPath('invalid/path.png'),
          );

          await pumpWithContentState(
            tester,
            child: const ProjectsSection(),
            state: _projectsState(
              right(<SectionItemLoad<Project>>[
                right(mixedProject),
              ]),
            ),
          );

          expect(find.text('A portfolio proof project.'), findsNWidgets(2));
          expect(find.byType(FieldFailureWidget), findsNWidgets(2));

          await tester.tap(find.text('View project details'));
          await tester.pump();

          expect(find.byType(FieldFailureWidget), findsNWidgets(3));
        },
      );

      testWidgets(
        'renders collection failures for required project lists',
        (tester) async {
          final invalidProject = buildProject().copyWith(
            stack: <SingleLineText>[],
            outcomes: <NonEmptyText>[],
          );

          await pumpWithContentState(
            tester,
            child: const ProjectsSection(),
            state: _projectsState(
              right(<SectionItemLoad<Project>>[
                right(invalidProject),
              ]),
            ),
          );

          await tester.tap(find.text('View project details'));
          await tester.pump();

          expect(find.byType(FieldFailureWidget), findsNWidgets(2));
          expect(find.text('Flutter'), findsNothing);
          expect(find.text('Delivered a maintainable baseline.'), findsNothing);
        },
      );

      testWidgets(
        'does not render optional hero media when heroImagePath is absent',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const ProjectsSection(),
            state: _projectsState(
              right(<SectionItemLoad<Project>>[
                right(buildProject()),
              ]),
            ),
          );

          await tester.tap(find.text('View project details'));
          await tester.pump();

          expect(find.byType(AssetMediaCard), findsNothing);
          expect(find.byType(FieldFailureWidget), findsNothing);
        },
      );

      testWidgets(
        'renders gallery media for projects that provide multiple screens',
        (tester) async {
          final worldOnProject = buildProject().copyWith(
            title: content_title.Title('World On'),
            heroImagePath: AssetPath(
              'assets/media/content/projects/world_on/world_on_home_and_search.png',
            ),
            galleryImagePaths: <AssetPath>[
              AssetPath(
                'assets/media/content/projects/world_on/world_on_home_and_search.png',
              ),
              AssetPath(
                'assets/media/content/projects/world_on/world_on_login.png',
              ),
              AssetPath(
                'assets/media/content/projects/world_on/world_on_profile_and_store.png',
              ),
            ],
          );

          await pumpWithContentState(
            tester,
            child: const ProjectsSection(),
            state: _projectsState(
              right(<SectionItemLoad<Project>>[
                right(worldOnProject),
              ]),
            ),
          );

          await tester.tap(find.text('View project details'));
          await tester.pump();

          expect(find.text('Selected screens'), findsOneWidget);
          expect(find.byType(AssetMediaCard), findsNWidgets(3));
        },
      );

      testWidgets(
        'renders item-level failures inline inside a successful section',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const ProjectsSection(),
            state: _projectsState(
              right(<SectionItemLoad<Project>>[
                right(buildProject()),
                const Left<AppFailure, Project>(
                  AppFailure.assetNotFound(
                    path: 'assets/content/projects/missing.json',
                  ),
                ),
              ]),
            ),
          );

          expect(find.text('PAMi'), findsNWidgets(2));
          expect(find.text('Unavailable project'), findsOneWidget);
          expect(find.byType(AppFailureCard), findsNothing);

          await tester.tap(
            find.byKey(const ValueKey<String>('entry-selector-item-1')),
          );
          await tester.pump();

          expect(find.text('PAMi'), findsOneWidget);
          expect(find.byType(AppFailureCard), findsOneWidget);
          expect(
            find.textContaining('assets/content/projects/missing.json'),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'renders section-level failure without project content',
        (tester) async {
          await pumpWithContentState(
            tester,
            child: const ProjectsSection(),
            state: _projectsState(
              left(
                const AppFailure.assetNotFound(
                  path: 'assets/content/projects/index.json',
                ),
              ),
            ),
          );

          expect(find.byType(AppFailureCard), findsOneWidget);
          expect(find.text('PAMi'), findsNothing);
          expect(find.text('Projects section unavailable'), findsOneWidget);
        },
      );
    },
  );
}

ContentState _projectsState(
  MultiEntrySectionLoad<Project> projectsLoad,
) => ContentState.initial().copyWith(
  status: ContentStatus.loaded,
  projectsOption: some(projectsLoad),
);
