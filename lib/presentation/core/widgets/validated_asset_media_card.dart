import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_colors.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/preview_frame_surface.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

part 'validated_asset_media_card/media_fallback_body.dart';

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
class AssetMediaCard extends StatefulWidget {
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
  State<AssetMediaCard> createState() => _AssetMediaCardState();
}

class _AssetMediaCardState extends State<AssetMediaCard> {
  static const _activationViewportMargin = 160.0;

  ScrollPosition? _scrollPosition;
  bool _shouldLoadImage = false;
  bool _hasCompletedInitialCheck = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachScrollListener();
    _scheduleInitialVisibilityCheck();
  }

  @override
  void didUpdateWidget(covariant AssetMediaCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.path != oldWidget.path) {
      _shouldLoadImage = false;
      _hasCompletedInitialCheck = false;
      _attachScrollListener();
      _scheduleInitialVisibilityCheck();
    }
  }

  @override
  void dispose() {
    _detachScrollListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = ContentCard(
      padding: AppSpacing.zero,
      onTap: widget.onTap,
      child: PreviewFrameSurface(
        height: widget.height,
        borderRadius: AppRadii.card,
        color: AppColors.surfaceSecondary,
        child: _buildMediaContent(),
      ),
    );

    final tooltipMessage = widget.tooltip;
    if (tooltipMessage == null || tooltipMessage.isEmpty) {
      return card;
    }

    return Tooltip(
      message: tooltipMessage,
      child: card,
    );
  }

  Widget _buildMediaContent() {
    if (!_shouldLoadImage) {
      return _MediaPlaceholderBody(
        label: widget.label,
        icon: widget.icon,
      );
    } else {
      return Image.asset(
        widget.path,
        fit: widget.fit,
        semanticLabel: widget.label,
        errorBuilder: (context, error, stackTrace) => _MediaFallbackBody(
          label: widget.label,
          icon: widget.icon,
        ),
      );
    }
  }

  void _attachScrollListener() {
    if (_shouldLoadImage) {
      _detachScrollListener();

      return;
    }

    final scrollableState = Scrollable.maybeOf(context);
    final nextPosition = scrollableState?.position;

    if (_scrollPosition == nextPosition) {
      return;
    }

    _detachScrollListener();
    _scrollPosition = nextPosition;
    _scrollPosition?.addListener(_handleScrollChanged);

    if (_scrollPosition == null) {
      _activateImage();
    }
  }

  void _detachScrollListener() {
    _scrollPosition?.removeListener(_handleScrollChanged);
    _scrollPosition = null;
  }

  void _handleScrollChanged() {
    _checkImageVisibility();
  }

  void _scheduleInitialVisibilityCheck() {
    if (_shouldLoadImage || _hasCompletedInitialCheck) {
      return;
    }

    _hasCompletedInitialCheck = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _checkImageVisibility();
    });
  }

  void _checkImageVisibility() {
    if (_shouldLoadImage) {
      return;
    }

    if (_isNearViewport()) {
      _activateImage();
    }
  }

  void _activateImage() {
    if (_shouldLoadImage) {
      return;
    }

    _detachScrollListener();

    if (mounted) {
      setState(() {
        _shouldLoadImage = true;
      });
    } else {
      _shouldLoadImage = true;
    }
  }

  bool _isNearViewport() {
    final renderObject = context.findRenderObject();
    final scrollableState = Scrollable.maybeOf(context);
    final viewportRenderObject = scrollableState?.context.findRenderObject();

    if (renderObject is! RenderBox ||
        viewportRenderObject is! RenderBox ||
        !renderObject.hasSize) {
      return false;
    }

    if (!viewportRenderObject.hasSize) {
      return false;
    }

    final targetRect =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;
    final viewportRect =
        viewportRenderObject.localToGlobal(Offset.zero) &
        viewportRenderObject.size;
    final activationRect = viewportRect.inflate(_activationViewportMargin);

    return targetRect.bottom > activationRect.top &&
        targetRect.top < activationRect.bottom;
  }
}
