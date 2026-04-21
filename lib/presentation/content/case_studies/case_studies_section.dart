import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/case_study.dart';
import 'package:charlie_shub_portfolio/presentation/content/case_studies/widgets/case_study_entry_detail.dart';
import 'package:charlie_shub_portfolio/presentation/content/case_studies/widgets/case_study_selector_label.dart';
import 'package:charlie_shub_portfolio/presentation/content/section_state_builders.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entry_selector_panel.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _caseStudiesDescription =
    'Practice-based security and application security write-ups focused on '
    'structured analysis and defensive thinking.';

/// Renders the case studies section from loaded structured content.
class CaseStudiesSection extends StatelessWidget {
  /// Creates a case studies section.
  const CaseStudiesSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    buildWhen: (previous, current) =>
        previous.status != current.status ||
        previous.caseStudiesOption != current.caseStudiesOption,
    builder: (context, state) => SectionContainer(
      heading: const SectionHeadingText(
        text: 'Case Studies',
        icon: Icons.find_in_page_outlined,
      ),
      children: [
        const SectionSupportingText(
          text: _caseStudiesDescription,
        ),
        const SizedBox(height: AppSpacing.size16),
        ...buildSelectorSectionChildren(
          overallStatus: state.status,
          sectionOption: state.caseStudiesOption,
          loadingMessage: 'Loading case study content...',
          interruptedLoadingMessage:
              'Case studies could not be requested because content loading '
              'was interrupted.',
          unavailableTitle: 'Case studies section unavailable',
          emptyMessage: 'No case studies are available yet.',
          selectorBuilder: (items) =>
              EntrySelectorPanel<SectionItemLoad<CaseStudy>>(
                entries: items,
                initialSelectedIndex: preferredSuccessfulSectionItemIndex(
                  items,
                ),
                labelBuilder: (context, item, {required isSelected}) =>
                    CaseStudySelectorLabel(
                      item: item,
                      isSelected: isSelected,
                    ),
                detailBuilder: (context, item) => CaseStudyEntryDetail(
                  item: item,
                ),
              ),
        ),
      ],
    ),
  );
}
