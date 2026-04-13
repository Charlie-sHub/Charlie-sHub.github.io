import 'package:charlie_shub_portfolio/application/content/content_cubit.dart';
import 'package:charlie_shub_portfolio/application/content/content_state.dart';
import 'package:charlie_shub_portfolio/application/content/content_status.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Resume-backed profile summary surface used near the top of the home page.
class ProfileSummaryCard extends StatelessWidget {
  /// Creates a profile summary card.
  const ProfileSummaryCard({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ContentCubit, ContentState>(
    builder: (context, state) => state.resumeOption.fold(
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
        (resume) => _ResumeProfileSummaryCard(resume: resume),
      ),
    ),
  );
}

class _ResumeProfileSummaryCard extends StatelessWidget {
  const _ResumeProfileSummaryCard({
    required this.resume,
  });

  final Resume resume;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ContentCard(
      variant: AppSurfaceVariant.section,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: resume.name,
            style: AppTextStyles.authorName(context),
          ),
          const SizedBox(height: AppSpacing.size8),
          ValidatedText(
            field: resume.location,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.size12),
          ValidatedText(
            field: resume.summary,
            style: textTheme.bodyLarge,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.size16),
          ContentBlock(
            title: 'Contact',
            spacing: AppSpacing.size12,
            child: ExternalLinkList(
              links: resume.contactLinks,
              collectionFailure: collectionFailureOrNull(
                resume.contactLinks,
                minLength: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
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
        const HeadingText(text: 'Profile summary'),
        const SizedBox(height: AppSpacing.size8),
        SupportingText(text: message),
      ],
    ),
  );
}
