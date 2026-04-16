import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_button_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/utils/open_external_resource.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/action_card_footer.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Shared visual variants for external resource affordances.
enum ActionLinkVariant {
  /// Full clickable card surface with label, subtitle, and affordance.
  card,

  /// Compact sticky-profile contact button with label only.
  contactButton,

  /// Larger resume contact button with the same warm-accent treatment.
  contactButtonLarge,
}

/// Renders an external link reference from validated domain fields.
class ExternalLinkTile extends StatelessWidget {
  /// Creates an external link tile.
  const ExternalLinkTile({
    required this.linkReference,
    this.onTap,
    this.showUrl = false,
    this.variant = ActionLinkVariant.card,
    super.key,
  });

  /// The validated link reference to render.
  final LinkReference linkReference;

  /// The tap handler for opening or otherwise handling the link.
  final VoidCallback? onTap;

  /// Whether the URL should be shown under the label.
  final bool showUrl;

  /// The visual treatment used for the link affordance.
  final ActionLinkVariant variant;

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
        variant: variant,
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
    this.variant = ActionLinkVariant.card,
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

  /// The visual treatment used for the link affordance.
  final ActionLinkVariant variant;

  @override
  Widget build(BuildContext context) {
    final resolvedOnTap = resolveOpenExternalResource(url, onTap: onTap);

    if (variant == ActionLinkVariant.contactButton ||
        variant == ActionLinkVariant.contactButtonLarge) {
      final style = variant == ActionLinkVariant.contactButtonLarge
          ? AppButtonStyles.contactLinkLarge(context)
          : AppButtonStyles.contactLink(context);

      return TextButton(
        onPressed: resolvedOnTap,
        style: style,
        child: Text(label),
      );
    }

    return ContentCard(
      onTap: resolvedOnTap,
      isLink: true,
      padding: AppSpacing.externalLinkTilePadding,
      child: ActionCardFooter(
        label: label,
        subtitle: subtitle,
        actionLabel: actionLabel,
      ),
    );
  }
}
