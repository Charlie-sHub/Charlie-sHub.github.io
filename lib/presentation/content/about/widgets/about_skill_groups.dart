import 'package:charlie_shub_portfolio/domain/core/entities/about_skill_group.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/labeled_tag_group_card.dart';
import 'package:flutter/material.dart';

/// Renders the selected about skill groups with explicit collection failures.
class AboutSkillGroups extends StatelessWidget {
  /// Creates an about skill groups widget.
  const AboutSkillGroups({
    required this.skillGroups,
    super.key,
  });

  /// The skill groups to display.
  final List<AboutSkillGroup> skillGroups;

  @override
  Widget build(BuildContext context) {
    final collectionFailure = collectionFailureOrNull(
      skillGroups,
      minLength: 1,
    );

    if (collectionFailure != null) {
      return FieldFailureWidget(
        failure: collectionFailure,
      );
    } else {
      final children = <Widget>[];

      for (var index = 0; index < skillGroups.length; index++) {
        final group = skillGroups[index];
        children.add(
          LabeledTagGroupCard(
            label: group.label,
            items: group.items,
            collectionFailure: collectionFailureOrNull(
              group.items,
              minLength: 1,
            ),
          ),
        );

        if (index < skillGroups.length - 1) {
          children.add(const SizedBox(height: 12));
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }
  }
}
