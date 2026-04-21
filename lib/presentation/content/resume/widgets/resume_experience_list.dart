import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_experience_item.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/widgets/resume_experience_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Renders the professional experience list in the resume section.
class ResumeExperienceList extends StatelessWidget {
  /// Creates a resume experience list.
  const ResumeExperienceList({
    required this.items,
    super.key,
  });

  /// The experience items to display.
  final List<ResumeExperienceItem> items;

  @override
  Widget build(BuildContext context) {
    final collectionFailure = collectionFailureOrNull(
      items,
      minLength: 1,
    );

    if (collectionFailure != null) {
      return FieldFailureWidget(
        failure: collectionFailure,
      );
    } else {
      final children = <Widget>[];

      for (var index = 0; index < items.length; index++) {
        children.add(
          ResumeExperienceCard(item: items[index]),
        );

        if (index < items.length - 1) {
          children.add(const SizedBox(height: AppSpacing.size12));
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }
  }
}
