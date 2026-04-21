import 'package:charlie_shub_portfolio/domain/core/misc/enums/link_reference_kind.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_button_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/utils/open_external_resource.dart';
import 'package:flutter/material.dart';

part 'link_button/link_button_content.dart';

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

/// Shared icon mapping for semantically typed external links.
IconData iconForLinkKind(LinkReferenceKind kind) => switch (kind) {
  LinkReferenceKind.external => Icons.link_rounded,
  LinkReferenceKind.github => Icons.code_rounded,
  LinkReferenceKind.linkedin => Icons.badge_outlined,
  LinkReferenceKind.portfolio => Icons.home_outlined,
  LinkReferenceKind.repository => Icons.source_outlined,
  LinkReferenceKind.documentation => Icons.menu_book_outlined,
  LinkReferenceKind.credential => Icons.verified_outlined,
  LinkReferenceKind.resume => Icons.description_outlined,
};
