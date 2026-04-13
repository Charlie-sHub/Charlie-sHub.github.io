import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/project.dart';
import 'package:charlie_shub_portfolio/presentation/content/projects/widgets/project_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:flutter/material.dart';

/// Renders one project entry while keeping item failures local.
class ProjectEntryDetail extends StatelessWidget {
  /// Creates a project entry detail widget.
  const ProjectEntryDetail({
    required this.item,
    super.key,
  });

  /// The project load item to render.
  final SectionItemLoad<Project> item;

  @override
  Widget build(BuildContext context) => item.fold(
    (failure) => AppFailureCard(
      failure: failure,
      title: 'Project entry unavailable',
    ),
    (project) => ProjectCard(project: project),
  );
}
