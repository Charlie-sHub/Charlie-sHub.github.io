import 'package:charlie_shub_portfolio/domain/core/entities/entity_validation.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/resume.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_block.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_list.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/validated_placeholder.dart';
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
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedText(
            field: resume.name,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ValidatedText(
            field: resume.location,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ValidatedText(
            field: resume.summary,
            style: textTheme.bodyLarge,
          ),
          if (resume.resumePdfPath != null) ...[
            const SizedBox(height: 16),
            ValidatedPlaceholder(
              path: resume.resumePdfPath!,
              labelBuilder: _buildResumeLabel,
              height: 140,
              icon: Icons.description_outlined,
            ),
          ],
          const SizedBox(height: 16),
          ContentBlock(
            title: 'Contact links',
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

  static String _buildResumeLabel(String value) =>
      'Resume document available: ${value.split('/').last}';
}
