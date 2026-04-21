import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume_education_item.dart';
import 'package:charlie_shub_portfolio/presentation/content/resume/widgets/resume_education_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Renders the education list in the resume section.
class ResumeEducationList extends StatelessWidget {
  /// Creates a resume education list.
  const ResumeEducationList({
    required this.items,
    super.key,
  });

  /// The education items to display.
  final List<ResumeEducationItem> items;

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
          ResumeEducationCard(item: items[index]),
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
