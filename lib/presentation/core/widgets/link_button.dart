import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_button_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/utils/open_external_resource.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Canonical button widget for opening external resources.
class LinkButton extends StatelessWidget {
  /// Creates a link button.
  const LinkButton({
    required this.label,
    required this.url,
    required this.icon,
    this.onTap,
    this.size = LinkButtonSize.standard,
    super.key,
  });

  /// The primary label shown for the resource.
  final String label;

  /// The resource URL or URI to open.
  final String url;

  /// Leading icon used for quick recognition.
  final IconData icon;

  /// Optional tap override used mainly in tests.
  final VoidCallback? onTap;

  /// Shared size treatment for the button affordance.
  final LinkButtonSize size;

  @override
  Widget build(BuildContext context) {
    final resolvedOnTap = resolveOpenExternalResource(url, onTap: onTap);
    final usesLargeLayout = size == LinkButtonSize.large;

    return TextButton(
      onPressed: resolvedOnTap,
      style: AppButtonStyles.linkButton(
        context,
        size: size,
      ),
      child: _LinkButtonContent(
        label: label,
        icon: icon,
        expandLabel: !usesLargeLayout,
        balanceTrailingSlot: usesLargeLayout,
        textAlign: usesLargeLayout ? TextAlign.center : TextAlign.start,
      ),
    );
  }
}

/// Validates a link reference before rendering a link button.
class ValidatedLinkButton extends StatelessWidget {
  /// Creates a validated link button.
  const ValidatedLinkButton({
    required this.linkReference,
    this.onTap,
    this.leadingIcon,
    this.size = LinkButtonSize.standard,
    super.key,
  });

  /// The validated link reference to render.
  final LinkReference linkReference;

  /// The tap handler for opening or otherwise handling the link.
  final VoidCallback? onTap;

  /// Optional leading icon override used for quick recognition.
  final IconData? leadingIcon;

  /// Shared size treatment for the rendered link button.
  final LinkButtonSize size;

  @override
  Widget build(BuildContext context) => linkReference.label.value.fold(
    (failure) => FieldFailureWidget(
      failure: failure,
    ),
    (label) => linkReference.url.value.fold(
      (failure) => FieldFailureWidget(
        failure: failure,
      ),
      (url) => LinkButton(
        label: label,
        onTap: onTap,
        url: url,
        icon: leadingIcon ?? inferExternalLinkIcon(label: label, url: url),
        size: size,
      ),
    ),
  );
}

/// Shared icon inference used across external-link button wrappers.
IconData inferExternalLinkIcon({
  required String label,
  required String url,
}) {
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

class _LinkButtonContent extends StatelessWidget {
  const _LinkButtonContent({
    required this.label,
    required this.icon,
    required this.expandLabel,
    required this.balanceTrailingSlot,
    required this.textAlign,
  });

  final String label;
  final IconData icon;
  final bool expandLabel;
  final bool balanceTrailingSlot;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: AppLayout.actionLeadingIconSize,
        child: Icon(
          icon,
          size: AppLayout.actionLeadingIconSize,
        ),
      ),
      const SizedBox(width: AppSpacing.size8),
      if (expandLabel || balanceTrailingSlot)
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
      if (balanceTrailingSlot) ...[
        const SizedBox(width: AppSpacing.size8),
        const SizedBox(width: AppLayout.actionLeadingIconSize),
      ],
    ],
  );
}
