import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_surface_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/utils/open_external_resource.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_frame.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Clickable PDF preview surface that opens the full document in a new tab.
class PdfPreviewTile extends StatelessWidget {
  /// Creates a PDF preview tile.
  const PdfPreviewTile({
    required this.path,
    required this.title,
    this.subtitle,
    this.onTap,
    this.previewHeight = AppLayout.pdfPreviewHeight,
    this.actionLabel = 'Open PDF',
    super.key,
  });

  /// Relative repository path for the bundled PDF asset.
  final String path;

  /// Human-readable title for the preview tile.
  final String title;

  /// Optional secondary label shown under the title.
  final String? subtitle;

  /// Optional tap override used mainly in tests.
  final VoidCallback? onTap;

  /// Height of the in-page preview frame.
  final double previewHeight;

  /// Short action hint shown in the trailing affordance.
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final resolvedOnTap = resolveOpenExternalResource(path, onTap: onTap);

    return ContentCard(
      onTap: resolvedOnTap,
      isLink: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: AppSurfaceStyles.previewFrameDecoration(context),
            child: ClipRRect(
              borderRadius: AppRadii.selectorItem,
              child: PdfPreviewFrame(
                path: path,
                height: previewHeight,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.size12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingText(text: title),
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
        ],
      ),
    );
  }
}

/// Validates a document path before rendering a clickable PDF preview tile.
class ValidatedPdfPreviewTile extends StatelessWidget {
  /// Creates a validated PDF preview tile.
  const ValidatedPdfPreviewTile({
    required this.path,
    required this.title,
    this.subtitleBuilder = _defaultSubtitleBuilder,
    this.onTap,
    this.previewHeight = AppLayout.pdfPreviewHeight,
    this.actionLabel = 'Open PDF',
    super.key,
  });

  /// Validated path for the PDF asset.
  final ValueObject<String> path;

  /// Human-readable title for the preview tile.
  final String title;

  /// Builds the secondary label from the trusted path value.
  final String Function(String value) subtitleBuilder;

  /// Optional tap override used mainly in tests.
  final VoidCallback? onTap;

  /// Height of the preview frame.
  final double previewHeight;

  /// Short action hint shown in the trailing affordance.
  final String actionLabel;

  @override
  Widget build(BuildContext context) => path.value.fold(
    (failure) => FieldFailureWidget(
      failure: failure,
    ),
    (value) => PdfPreviewTile(
      path: value,
      title: title,
      subtitle: subtitleBuilder(value),
      onTap: onTap,
      previewHeight: previewHeight,
      actionLabel: actionLabel,
    ),
  );

  static String _defaultSubtitleBuilder(String value) => value.split('/').last;
}
