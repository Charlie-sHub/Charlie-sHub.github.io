import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/utils/open_external_resource.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Renders an external link reference from validated domain fields.
class ExternalLinkTile extends StatelessWidget {
  /// Creates an external link tile.
  const ExternalLinkTile({
    required this.linkReference,
    this.onTap,
    this.showUrl = false,
    super.key,
  });

  /// The validated link reference to render.
  final LinkReference linkReference;

  /// The tap handler for opening or otherwise handling the link.
  final VoidCallback? onTap;

  /// Whether the URL should be shown under the label.
  final bool showUrl;

  @override
  Widget build(BuildContext context) => linkReference.label.value.fold(
    (failure) => FieldFailureWidget(
      failure: failure,
    ),
    (label) => linkReference.url.value.fold(
      (failure) => FieldFailureWidget(
        failure: failure,
      ),
      (url) => _LinkTileContent(
        label: label,
        onTap: onTap,
        showUrl: showUrl,
        url: url,
      ),
    ),
  );
}

class _LinkTileContent extends StatelessWidget {
  const _LinkTileContent({
    required this.label,
    required this.url,
    required this.showUrl,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;
  final bool showUrl;
  final String url;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final resolvedOnTap = resolveOpenExternalResource(url, onTap: onTap);

    return ContentCard(
      onTap: resolvedOnTap,
      isLink: true,
      padding: AppSpacing.externalLinkTilePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingText(text: label),
                if (showUrl) const SizedBox(height: AppSpacing.size4),
                if (showUrl) SupportingText(text: url),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.size12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Open link',
                style: AppTextStyles.tag(context),
              ),
              const SizedBox(height: AppSpacing.size4),
              Icon(
                Icons.open_in_new,
                color: colorScheme.primary,
                size: AppLayout.externalLinkIndicatorIconSize,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
