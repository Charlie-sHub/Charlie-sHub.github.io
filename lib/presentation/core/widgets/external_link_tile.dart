import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_button_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
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
    this.leadingIcon,
    this.accentColor,
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

  /// Optional leading icon override used for quick recognition.
  final IconData? leadingIcon;

  /// Optional accent color override for card-style link affordances.
  final Color? accentColor;

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
        leadingIcon: leadingIcon,
        accentColor: accentColor,
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
    this.leadingIcon,
    this.accentColor,
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

  /// Optional leading icon override used for quick recognition.
  final IconData? leadingIcon;

  /// Optional accent color override for card-style link affordances.
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final resolvedOnTap = resolveOpenExternalResource(url, onTap: onTap);
    final resolvedLeadingIcon = leadingIcon ?? _inferLeadingIcon();

    if (variant == ActionLinkVariant.contactButton ||
        variant == ActionLinkVariant.contactButtonLarge) {
      final buttonSize = variant == ActionLinkVariant.contactButtonLarge
          ? ContactButtonSize.large
          : ContactButtonSize.compact;

      return TextButton(
        onPressed: resolvedOnTap,
        style: AppButtonStyles.contactLink(
          context,
          size: buttonSize,
        ),
        child: _ContactButtonContent(
          label: label,
          icon: resolvedLeadingIcon,
          contentWidth: buttonSize == ContactButtonSize.compact
              ? AppLayout.homeProfileContactContentWidth
              : null,
          expandLabel: buttonSize == ContactButtonSize.compact,
          textAlign: buttonSize == ContactButtonSize.compact
              ? TextAlign.start
              : TextAlign.center,
        ),
      );
    }

    return ContentCard(
      onTap: resolvedOnTap,
      isLink: true,
      accentColor: accentColor,
      padding: AppSpacing.externalLinkTilePadding,
      child: ActionCardFooter(
        label: label,
        subtitle: subtitle,
        actionLabel: actionLabel,
        leadingIcon: resolvedLeadingIcon,
        accentColor: accentColor,
      ),
    );
  }

  IconData _inferLeadingIcon() {
    final normalizedLabel = label.toLowerCase();
    final normalizedUrl = url.toLowerCase();

    if (normalizedUrl.startsWith('mailto:') || normalizedLabel == 'email') {
      return Icons.mail_outline_rounded;
    } else if (normalizedLabel.contains('github') ||
        normalizedUrl.contains('github.com')) {
      return Icons.code_rounded;
    } else if (normalizedLabel.contains('linkedin') ||
        normalizedUrl.contains('linkedin.com')) {
      return Icons.badge_outlined;
    } else if (normalizedLabel.contains('resume') ||
        normalizedLabel.contains('cv')) {
      return Icons.description_outlined;
    } else if (normalizedLabel.contains('repository') ||
        normalizedLabel.contains('repo')) {
      return Icons.source_outlined;
    } else if (normalizedLabel.contains('document') ||
        normalizedLabel.contains('documentation') ||
        normalizedLabel.contains('docs')) {
      return Icons.menu_book_outlined;
    } else if (normalizedLabel.contains('certificate') ||
        normalizedLabel.contains('credential') ||
        normalizedLabel.contains('proof')) {
      return Icons.verified_outlined;
    } else {
      return Icons.link_rounded;
    }
  }
}

class _ContactButtonContent extends StatelessWidget {
  const _ContactButtonContent({
    required this.label,
    required this.icon,
    required this.expandLabel,
    required this.textAlign,
    this.contentWidth,
  });

  final String label;
  final IconData icon;
  final bool expandLabel;
  final TextAlign textAlign;
  final double? contentWidth;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: contentWidth,
      child: Row(
        mainAxisSize: contentWidth == null
            ? MainAxisSize.min
            : MainAxisSize.max,
        children: [
          SizedBox(
            width: AppLayout.actionLeadingIconSize,
            child: Icon(
              icon,
              size: AppLayout.actionLeadingIconSize,
            ),
          ),
          const SizedBox(width: AppSpacing.size8),
          if (expandLabel)
            Expanded(
              child: Text(
                label,
                textAlign: textAlign,
              ),
            )
          else
            Text(
              label,
              textAlign: textAlign,
            ),
        ],
      ),
    ),
  );
}
