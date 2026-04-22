import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/profile_summary/profile_summary_content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/profile_summary/profile_summary_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Profile summary surface used near the top of the home page.
class ProfileSummaryCard extends StatelessWidget {
  /// Creates a profile summary card.
  const ProfileSummaryCard({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    buildWhen: (previous, current) =>
        previous.status != current.status ||
        previous.aboutOption != current.aboutOption ||
        previous.resumeOption != current.resumeOption,
    builder: (context, state) {
      final about = _loadedAbout(state);

      return state.resumeOption.fold(
        () => ProfileSummaryStatusCard(
          message: state.status == ContentStatus.failure
              ? 'Profile summary is temporarily unavailable.'
              : 'Loading profile summary...',
        ),
        (resumeLoad) => resumeLoad.fold(
          (_) => const ProfileSummaryStatusCard(
            message: 'Profile summary is temporarily unavailable.',
          ),
          (resume) => ProfileSummaryContentCard(
            resume: resume,
            about: about,
          ),
        ),
      );
    },
  );

  About? _loadedAbout(ContentState state) => state.aboutOption.fold(
    () => null,
    (aboutLoad) => aboutLoad.fold(
      (_) => null,
      (about) => about,
    ),
  );
}
