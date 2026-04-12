import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entry_selector_labels.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Builds the selector label for one course entry.
class CourseSelectorLabel extends StatelessWidget {
  /// Creates a course selector label.
  const CourseSelectorLabel({
    required this.item,
    required this.isSelected,
    super.key,
  });

  /// The course load item represented in the selector.
  final SectionItemLoad<Course> item;

  /// Whether this selector item is currently selected.
  final bool isSelected;

  @override
  Widget build(BuildContext context) => item.fold(
    (_) => UnavailableEntrySelectorLabel(
      title: 'Unavailable course',
      isSelected: isSelected,
    ),
    (course) => EntrySelectorLabel(
      title: ValidatedText(
        field: course.title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: ValidatedText(
        field: course.courseDetails.provider,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
