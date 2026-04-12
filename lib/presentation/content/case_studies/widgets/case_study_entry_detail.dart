import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/presentation/content/case_studies/widgets/case_study_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
import 'package:flutter/material.dart';

/// Renders one case-study entry while keeping item failures local.
class CaseStudyEntryDetail extends StatelessWidget {
  /// Creates a case-study entry detail widget.
  const CaseStudyEntryDetail({
    required this.item,
    super.key,
  });

  /// The case-study load item to render.
  final SectionItemLoad<CaseStudy> item;

  @override
  Widget build(BuildContext context) => item.fold(
    (failure) => AppFailureCard(
      failure: failure,
      title: 'Case study entry unavailable',
    ),
    (caseStudy) => CaseStudyCard(caseStudy: caseStudy),
  );
}
