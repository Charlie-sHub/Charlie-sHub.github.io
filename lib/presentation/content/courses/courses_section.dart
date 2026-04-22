import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/presentation/content/courses/widgets/course_entry_detail.dart';
import 'package:charlie_shub_portfolio/presentation/content/courses/widgets/course_selector_label.dart';
import 'package:charlie_shub_portfolio/presentation/content/section_state_builders.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entry_selector_panel.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Renders the courses section from loaded structured content.
class CoursesSection extends StatelessWidget {
  /// Creates a courses section.
  const CoursesSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    buildWhen: (previous, current) =>
        previous.status != current.status ||
        previous.coursesOption != current.coursesOption,
    builder: (context, state) => SectionContainer(
      heading: const SectionHeadingText(
        text: 'Courses',
        icon: Icons.school_outlined,
      ),
      children: buildSelectorSectionChildren(
        overallStatus: state.status,
        sectionOption: state.coursesOption,
        loadingMessage: 'Loading course content...',
        interruptedLoadingMessage: 'Courses are temporarily unavailable.',
        unavailableTitle: 'Courses section unavailable',
        emptyMessage: 'No courses are available yet.',
        selectorBuilder: (items) => EntrySelectorPanel<SectionItemLoad<Course>>(
          entries: items,
          initialSelectedIndex: preferredSuccessfulSectionItemIndex(items),
          labelBuilder: (context, item, {required isSelected}) =>
              CourseSelectorLabel(
                item: item,
                isSelected: isSelected,
              ),
          detailBuilder: (context, item) => CourseEntryDetail(
            item: item,
          ),
        ),
      ),
    ),
  );
}
