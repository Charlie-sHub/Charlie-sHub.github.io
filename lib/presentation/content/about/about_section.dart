import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/presentation/content/about/widgets/about_narrative_card.dart';
import 'package:charlie_shub_portfolio/presentation/content/section_state_builders.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/section_container.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Renders the about section from loaded structured content.
class AboutSection extends StatelessWidget {
  /// Creates an about section.
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    buildWhen: (previous, current) =>
        previous.status != current.status ||
        previous.aboutOption != current.aboutOption,
    builder: (context, state) => SectionContainer(
      heading: const SectionHeadingText(
        text: 'About',
        icon: Icons.tune_rounded,
      ),
      children: buildSingleEntrySectionChildren(
        overallStatus: state.status,
        sectionOption: state.aboutOption,
        loadingMessage: 'Loading about content...',
        interruptedLoadingMessage:
            'About content could not be requested because content loading '
            'was interrupted.',
        unavailableTitle: 'About section unavailable',
        loadedBuilder: (about) => <Widget>[
          AboutNarrativeCard(about: about),
        ],
      ),
    ),
  );
}
