import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/content/content_load_types.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/certification.dart';
import 'package:charlie_shub_portfolio/presentation/content/certifications/widgets/certification_entry_detail.dart';
import 'package:charlie_shub_portfolio/presentation/content/certifications/widgets/certification_selector_label.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/app_failure_card.dart';
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
      children: _buildSectionChildren(state),
    ),
  );

  List<Widget> _buildSectionChildren(
    ContentState state,
  ) => state.certificationsOption.fold(
    () => <Widget>[
      SectionSupportingText(
        text: state.status == ContentStatus.failure
            ? 'Certifications could not be requested because content '
                  'loading was interrupted.'
            : 'Loading certification content...',
      ),
    ],
    (sectionLoad) => sectionLoad.fold(
      (failure) => <Widget>[
        AppFailureCard(
          failure: failure,
          title: 'Certifications section unavailable',
        ),
      ],
      (items) {
        if (items.isEmpty) {
          return const <Widget>[
            SectionSupportingText(
              text: 'No certification entries are available yet.',
            ),
          ];
        } else {
          return <Widget>[
            EntrySelectorPanel<SectionItemLoad<Certification>>(
              entries: items,
              initialSelectedIndex: _preferredSelectedIndex(items),
              labelBuilder: (context, item, {required isSelected}) =>
                  CertificationSelectorLabel(
                    item: item,
                    isSelected: isSelected,
                  ),
              detailBuilder: (context, item) => CertificationEntryDetail(
                item: item,
              ),
            ),
          ];
        }
      },
    ),
  );

  int _preferredSelectedIndex(List<SectionItemLoad<Certification>> items) {
    final successfulIndex = items.indexWhere((item) => item.isRight());

    if (successfulIndex == -1) {
      return 0;
    }

    return successfulIndex;
  }
}
