import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/presentation/content/certifications/widgets/certification_entry_detail.dart';
import 'package:charlie_shub_portfolio/presentation/content/certifications/widgets/certification_selector_label.dart';
import 'package:charlie_shub_portfolio/presentation/content/section_state_builders.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/entry_selector_panel.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Renders the certifications section from loaded structured content.
class CertificationsSection extends StatelessWidget {
  /// Creates a certifications section.
  const CertificationsSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    buildWhen: (previous, current) =>
        previous.status != current.status ||
        previous.certificationsOption != current.certificationsOption,
    builder: (context, state) => SectionContainer(
      heading: const SectionHeadingText(
        text: 'Certifications',
        icon: Icons.verified_outlined,
      ),
      children: buildSelectorSectionChildren(
        overallStatus: state.status,
        sectionOption: state.certificationsOption,
        loadingMessage: 'Loading certification content...',
        interruptedLoadingMessage:
            'Certifications could not be requested because content loading '
            'was interrupted.',
        unavailableTitle: 'Certifications section unavailable',
        emptyMessage: 'No certification entries are available yet.',
        selectorBuilder: (items) =>
            EntrySelectorPanel<SectionItemLoad<Certification>>(
              entries: items,
              initialSelectedIndex: preferredSuccessfulSectionItemIndex(items),
              labelBuilder: (context, item, {required isSelected}) =>
                  CertificationSelectorLabel(
                    item: item,
                    isSelected: isSelected,
                  ),
              detailBuilder: (context, item) => CertificationEntryDetail(
                item: item,
              ),
            ),
      ),
    ),
  );
}
