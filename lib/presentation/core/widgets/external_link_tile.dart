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
      (url) => ActionLinkTile(
        label: label,
        onTap: onTap,
        url: url,
        subtitle: showUrl ? url : null,
      ),
    ),
  );
}

/// Renders a simple action tile that opens a URL-like resource.
class ActionLinkTile extends StatelessWidget {
  /// Creates an action link tile.
  const ActionLinkTile({
    required this.label,
    required this.url,
    this.subtitle,
    this.actionLabel = 'Open link',
    this.onTap,
    super.key,
  });

  /// The primary label shown for the resource.
  final String label;

  /// The resource URL or URI to open.
  final String url;

  /// Optional secondary text shown under the label.
  final String? subtitle;

  /// Short action hint shown beside the tile affordance.
  final String actionLabel;

  /// Optional tap override used mainly in tests.
  final VoidCallback? onTap;

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
                if (subtitle case final subtitle?) ...[
                  const SizedBox(height: AppSpacing.size4),
                  SupportingText(text: subtitle),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.size12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                actionLabel,
                style: AppTextStyles.actionLabel(context),
              ),
              const SizedBox(height: AppSpacing.size4),
              Icon(
                Icons.open_in_new,
                color: colorScheme.secondary,
                size: AppLayout.externalLinkIndicatorIconSize,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
