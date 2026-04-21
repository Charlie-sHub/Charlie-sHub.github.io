import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Status surface used when the profile summary is loading or unavailable.
class ProfileSummaryStatusCard extends StatelessWidget {
  /// Creates the profile-summary status card.
  const ProfileSummaryStatusCard({
    required this.message,
    super.key,
  });

  /// Supporting status message shown below the heading.
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
