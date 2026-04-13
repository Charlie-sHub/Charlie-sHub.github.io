import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entry_selector_labels.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Builds the selector label for one project entry.
class ProjectSelectorLabel extends StatelessWidget {
  /// Creates a project selector label.
  const ProjectSelectorLabel({
    required this.item,
    required this.isSelected,
    super.key,
  });

  /// The project load item represented in the selector.
  final SectionItemLoad<Project> item;

  /// Whether this selector item is currently selected.
  final bool isSelected;

  @override
  Widget build(BuildContext context) => item.fold(
    (_) => UnavailableEntrySelectorLabel(
      title: 'Unavailable project',
      isSelected: isSelected,
    ),
    (project) => EntrySelectorLabel(
      title: ValidatedText(
        field: project.title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: ValidatedText(
        field: project.summary,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
