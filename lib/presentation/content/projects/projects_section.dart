import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/presentation/content/projects/widgets/project_entry_detail.dart';
import 'package:charlie_shub_portfolio/presentation/content/projects/widgets/project_selector_label.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entry_selector_panel.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Renders the projects section from loaded structured content.
class ProjectsSection extends StatelessWidget {
  /// Creates a projects section.
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    buildWhen: (previous, current) =>
        previous.status != current.status ||
        previous.projectsOption != current.projectsOption,
    builder: (context, state) => SectionContainer(
      heading: const SectionHeadingText(
        text: 'Projects',
        icon: Icons.folder_open_outlined,
      ),
      children: _buildSectionChildren(state),
    ),
  );

  List<Widget> _buildSectionChildren(
    ContentState state,
  ) => state.projectsOption.fold(
    () => <Widget>[
      SectionSupportingText(
        text: state.status == ContentStatus.failure
            ? 'Projects could not be requested because content '
                  'loading was interrupted.'
            : 'Loading project content...',
      ),
    ],
    (sectionLoad) => sectionLoad.fold(
      (failure) => <Widget>[
        AppFailureCard(
          failure: failure,
          title: 'Projects section unavailable',
        ),
      ],
      (items) {
        if (items.isEmpty) {
          return const <Widget>[
            SectionSupportingText(
              text: 'No project entries are available yet.',
            ),
          ];
        } else {
          return <Widget>[
            EntrySelectorPanel<SectionItemLoad<Project>>(
              entries: items,
              initialSelectedIndex: _preferredSelectedIndex(items),
              labelBuilder: (context, item, {required isSelected}) =>
                  ProjectSelectorLabel(
                    item: item,
                    isSelected: isSelected,
                  ),
              detailBuilder: (context, item) => ProjectEntryDetail(
                item: item,
              ),
            ),
          ];
        }
      },
    ),
  );

  int _preferredSelectedIndex(List<SectionItemLoad<Project>> items) {
    final successfulIndex = items.indexWhere((item) => item.isRight());

    if (successfulIndex == -1) {
      return 0;
    }

    return successfulIndex;
  }
}
