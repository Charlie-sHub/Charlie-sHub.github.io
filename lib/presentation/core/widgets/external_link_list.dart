import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_tile.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Renders a vertical list of external link tiles with explicit collection
/// failure handling.
class ExternalLinkList extends StatelessWidget {
  /// Creates an external link list.
  const ExternalLinkList({
    required this.links,
    this.collectionFailure,
    this.onLinkTap,
    this.showUrls = true,
    super.key,
  });

  /// The validated links to render.
  final List<LinkReference> links;

  /// The collection-level validation failure to render, if any.
  final ValueFailure<dynamic>? collectionFailure;

  /// The optional tap callback for each link.
  final void Function(LinkReference link)? onLinkTap;

  /// Whether each tile should display its URL.
  final bool showUrls;

  @override
  Widget build(BuildContext context) {
    if (collectionFailure != null) {
      return FieldFailureWidget(
        failure: collectionFailure!,
      );
    }

    final children = <Widget>[];

    for (var index = 0; index < links.length; index++) {
      final link = links[index];
      children.add(
        ExternalLinkTile(
          linkReference: link,
          onTap: onLinkTap == null ? null : () => onLinkTap!(link),
          showUrl: showUrls,
        ),
      );

      if (index < links.length - 1) {
        children.add(const SizedBox(height: 12));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
