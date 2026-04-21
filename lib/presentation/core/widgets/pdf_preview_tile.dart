import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/utils/open_external_resource.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/action_card_footer.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/pdf_preview_frame.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/preview_frame_surface.dart';
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
    final resolvedOnTap = resolveOpenExternalResource(
      path,
      onTap: onTap,
    );
    final borderColor = Theme.of(context).colorScheme.outlineVariant;

    return ContentCard(
      onTap: resolvedOnTap,
      isLink: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PreviewFrameSurface(
            height: previewHeight,
            borderRadius: AppRadii.control,
            color: AppColors.surfaceSecondary,
            border: Border.all(color: borderColor),
            child: PdfPreviewFrame(
              path: path,
              height: previewHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.size12),
          ActionCardFooter(
            label: title,
            subtitle: subtitle,
            actionLabel: actionLabel,
            leadingIcon: Icons.picture_as_pdf_outlined,
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
