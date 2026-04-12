import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/presentation/content/courses/widgets/course_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:flutter/material.dart';

/// Renders one course entry while keeping item failures local.
class CourseEntryDetail extends StatelessWidget {
  /// Creates a course entry detail widget.
  const CourseEntryDetail({
    required this.item,
    super.key,
  });

  /// The course load item to render.
  final SectionItemLoad<Course> item;

  @override
  Widget build(BuildContext context) => item.fold(
    (failure) => AppFailureCard(
      failure: failure,
      title: 'Course entry unavailable',
    ),
    (course) => CourseCard(course: course),
  );
}
