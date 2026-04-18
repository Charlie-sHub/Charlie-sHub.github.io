import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/contact_action_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _profileSummaryImageAsset = 'assets/media/notion_icon.png';
const _profileSummaryImageKey = ValueKey<String>('profile-summary-image');
const _profileSummaryInnerCardKey = ValueKey<String>(
  'profile-summary-inner-card',
);

/// Profile summary surface used near the top of the home page.
class ProfileSummaryCard extends StatelessWidget {
  /// Creates a profile summary card.
  const ProfileSummaryCard({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    builder: (context, state) {
      final about = _loadedAbout(state);

      return state.resumeOption.fold(
        () => _ProfileSummaryStatusCard(
          message: state.status == ContentStatus.failure
              ? 'Profile summary could not be requested because content '
                    'loading was interrupted.'
              : 'Loading profile summary...',
        ),
        (resumeLoad) => resumeLoad.fold(
          (_) => const _ProfileSummaryStatusCard(
            message: 'Profile summary is temporarily unavailable.',
          ),
          (resume) => _ProfileSummaryContentCard(
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

class _ProfileSummaryContentCard extends StatelessWidget {
  const _ProfileSummaryContentCard({
    required this.resume,
    required this.about,
  });

  final Resume resume;
  final About? about;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ContentCard(
      variant: AppSurfaceVariant.section,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: ValidatedText(
              field: resume.name,
              style: AppTextStyles.authorName(context),
            ),
          ),
          const SizedBox(height: AppSpacing.size16),
          ContactActionList(
            links: resume.contactLinks,
          ),
          const SizedBox(height: AppSpacing.size16),
          ContentCard(
            key: _profileSummaryInnerCardKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: _ProfileSummaryImage(),
                ),
                const SizedBox(height: AppSpacing.size16),
                ValidatedText(
                  field: _summaryField,
                  style: textTheme.bodyLarge,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  NonEmptyText get _summaryField =>
      about?.professionalSummaryShort ?? resume.summary;
}

class _ProfileSummaryStatusCard extends StatelessWidget {
  const _ProfileSummaryStatusCard({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) => ContentCard(
    variant: AppSurfaceVariant.section,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeadingText(text: 'Profile summary'),
        const SizedBox(height: AppSpacing.size8),
        SectionSupportingText(text: message),
      ],
    ),
  );
}

class _ProfileSummaryImage extends StatelessWidget {
  const _ProfileSummaryImage();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    key: _profileSummaryImageKey,
    decoration: AppSurfaceStyles.previewFrameDecoration(
      context,
    ).copyWith(borderRadius: AppRadii.card),
    child: ClipRRect(
      borderRadius: AppRadii.card,
      child: SizedBox.square(
        dimension: AppLayout.homeProfileSummaryImageSize,
        child: Image.asset(
          _profileSummaryImageAsset,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
