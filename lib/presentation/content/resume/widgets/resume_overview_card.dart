import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/contact_action_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_tile.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_text.dart';
import 'package:flutter/material.dart';

/// Shows the high-level resume overview content.
class ResumeOverviewCard extends StatelessWidget {
  /// Creates a resume overview card.
  const ResumeOverviewCard({
    required this.resume,
    super.key,
  });

  /// The resume content to render.
  final Resume resume;

  @override
  Widget build(BuildContext context) => ContentCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValidatedText(
          field: resume.name,
          style: AppTextStyles.contentTitle(context),
        ),
        const SizedBox(height: AppSpacing.size8),
        ValidatedText(
          field: resume.location,
          style: AppTextStyles.contentSubtitle(context),
        ),
        const SizedBox(height: AppSpacing.size12),
        ValidatedText(
          field: resume.summary,
          style: AppTextStyles.body(context),
        ),
        if (resume.resumePdfPath != null) ...[
          const SizedBox(height: AppSpacing.size16),
          ValidatedPdfPreviewTile(
            path: resume.resumePdfPath!,
            title: 'Resume PDF',
          ),
        ],
        const SizedBox(height: AppSpacing.size16),
        ContentBlock(
          title: 'Contact links',
          child: ContactActionList(
            links: resume.contactLinks,
            collectionFailure: collectionFailureOrNull(
              resume.contactLinks,
              minLength: 1,
            ),
            size: ContactActionSize.large,
            layout: ContactActionLayout.row,
          ),
        ),
      ],
    ),
  );
}
