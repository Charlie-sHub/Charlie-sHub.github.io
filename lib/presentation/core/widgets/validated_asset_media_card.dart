import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

/// Validates an asset path before rendering an asset-backed media card.
class ValidatedAssetMediaCard extends StatelessWidget {
  /// Creates a validated asset media card.
  const ValidatedAssetMediaCard({
    required this.path,
    required this.labelBuilder,
    this.height = AppLayout.mediaPlaceholderHeight,
    this.fit = BoxFit.cover,
    this.icon = Icons.image_outlined,
    this.onTap,
    this.tooltip,
    super.key,
  });

  /// The validated asset path to render.
  final ValueObject<String> path;

  /// Builds the fallback label from the trusted path value.
  final String Function(String value) labelBuilder;

  /// The media height.
  final double height;

  /// The image fit used when the asset renders successfully.
  final BoxFit fit;

  /// The fallback icon shown if the asset cannot be rendered.
  final IconData icon;

  /// Optional tap handler for interactive media cards.
  final VoidCallback? onTap;

  /// Optional tooltip shown for interactive media cards.
  final String? tooltip;

  @override
  Widget build(BuildContext context) => path.value.fold(
    (failure) => FieldFailureWidget(
      failure: failure,
    ),
    (value) => AssetMediaCard(
      path: value,
      label: labelBuilder(value),
      height: height,
      fit: fit,
      icon: icon,
      onTap: onTap,
      tooltip: tooltip,
    ),
  );
}

/// Renders an asset-backed media card with a graceful inline fallback.
class AssetMediaCard extends StatelessWidget {
  /// Creates an asset media card.
  const AssetMediaCard({
    required this.path,
    required this.label,
    this.height = AppLayout.mediaPlaceholderHeight,
    this.fit = BoxFit.cover,
    this.icon = Icons.image_outlined,
    this.onTap,
    this.tooltip,
    super.key,
  });

  /// The asset path to render.
  final String path;

  /// The fallback label to show if the asset cannot load.
  final String label;

  /// The media height.
  final double height;

  /// The image fit used when the asset renders successfully.
  final BoxFit fit;

  /// The fallback icon shown if the asset cannot be rendered.
  final IconData icon;

  /// Optional tap handler for interactive media cards.
  final VoidCallback? onTap;

  /// Optional tooltip shown for interactive media cards.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final card = ContentCard(
      padding: AppSpacing.zero,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: AppRadii.card,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: ColoredBox(
            color: AppColors.surfaceSecondary,
            child: Image.asset(
              path,
              fit: fit,
              errorBuilder: (context, error, stackTrace) => _MediaFallbackBody(
                label: label,
                icon: icon,
              ),
            ),
          ),
        ),
      ),
    );

    final tooltipMessage = tooltip;
    if (tooltipMessage == null || tooltipMessage.isEmpty) {
      return card;
    }

    return Tooltip(
      message: tooltipMessage,
      child: card,
    );
  }
}

class _MediaFallbackBody extends StatelessWidget {
  const _MediaFallbackBody({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.size16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: colorScheme.secondary,
            ),
            const SizedBox(height: AppSpacing.size12),
            SupportingText(text: label),
          ],
        ),
      ),
    );
  }
}
