import 'package:charlie_shub_portfolio/domain/core/entities/about.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_bullet_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Shows the structured narrative content for the about section.
class AboutNarrativeCard extends StatelessWidget {
  /// Creates an about narrative card.
  const AboutNarrativeCard({
    required this.about,
    super.key,
  });

  /// The about content to render.
  final About about;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: about.title,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'Engineering background',
            child: ValidatedText(
              field: about.developmentBackground,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'Working style',
            child: ValidatedBulletList(
              items: about.strengthsAndWorkingStyle,
              collectionFailure: collectionFailureOrNull(
                about.strengthsAndWorkingStyle,
                minLength: 1,
              ),
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'How I build software',
            child: ValidatedText(
              field: about.howIBuildSoftware,
              style: textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'How development and security connect',
            child: ValidatedText(
              field: about.howDevelopmentAndSecurityConnect,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
