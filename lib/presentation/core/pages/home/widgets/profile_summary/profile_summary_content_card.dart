import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/presentation/core/pages/home/widgets/profile_summary/profile_summary_image.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/contact/contact_action_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

const _profileSummaryInnerCardKey = ValueKey<String>(
  'profile-summary-inner-card',
);

/// Resolved content state for the home-page profile summary.
class ProfileSummaryContentCard extends StatelessWidget {
  /// Creates the profile-summary content card.
  const ProfileSummaryContentCard({
    required this.resume,
    required this.about,
    super.key,
  });

  /// Resume content used to render the primary identity and contact actions.
  final Resume resume;

  /// Optional about content used for the short summary and profile image.
  final About? about;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ContentCard(
      variant: AppSurfaceVariant.section,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentCard(
            key: _profileSummaryInnerCardKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ValidatedText(
                        field: resume.name,
                        style: AppTextStyles.authorName(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_profileImagePath != null) ...[
                      const SizedBox(width: AppSpacing.size12),
                      ProfileSummaryImage(path: _profileImagePath!),
                    ],
                  ],
                ),
                ValidatedText(
                  field: _summaryField,
                  style: textTheme.bodyLarge,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.size16),
          ContactActionList(
            directEmailAddress: resume.directEmailAddress,
            links: resume.contactLinks,
          ),
        ],
      ),
    );
  }

  NonEmptyText get _summaryField =>
      about?.professionalSummaryShort ?? resume.summary;

  AssetPath? get _profileImagePath => about?.profileImagePath;
}
