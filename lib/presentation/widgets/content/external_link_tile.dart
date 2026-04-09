import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/content_card.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/core/text_widgets.dart';
import 'package:charlie_shub_portfolio/presentation/widgets/feedback/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Renders an external link reference from validated domain fields.
class ExternalLinkTile extends StatelessWidget {
  /// Creates an external link tile.
  const ExternalLinkTile({
    required this.linkReference,
    this.onTap,
    this.showUrl = true,
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

    final content = ContentCard(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingText(text: label),
                if (showUrl) const SizedBox(height: 4),
                if (showUrl) SupportingText(text: url),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.open_in_new,
            color: colorScheme.primary,
            size: 18,
          ),
        ],
      ),
    );

    if (onTap == null) {
      return Semantics(
        link: true,
        child: content,
      );
    }

    return Semantics(
      button: true,
      link: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: content,
        ),
      ),
    );
  }
}
