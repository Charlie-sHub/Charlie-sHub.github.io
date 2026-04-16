import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_tile.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

const _directEmailAddress = 'carlosrafael-mg@hotmail.com';

/// Renders the shared portfolio contact actions used by profile surfaces.
class ContactActionList extends StatelessWidget {
  /// Creates a contact action list.
  const ContactActionList({
    required this.links,
    this.collectionFailure,
    this.variant = ActionLinkVariant.contactButton,
    super.key,
  });

  /// Structured contact links sourced from the resume content.
  final List<LinkReference> links;

  /// The collection-level validation failure to render, if any.
  final ValueFailure<dynamic>? collectionFailure;

  /// The button treatment used for the rendered contact actions.
  final ActionLinkVariant variant;

  @override
  Widget build(BuildContext context) {
    if (collectionFailure != null) {
      return FieldFailureWidget(
        failure: collectionFailure!,
      );
    }

    final visibleLinks = links.where(_shouldKeepContactLink).toList();
    final children = <Widget>[
      ActionLinkTile(
        label: 'Email',
        url: 'mailto:$_directEmailAddress',
        variant: variant,
      ),
    ];

    for (final link in visibleLinks) {
      children
        ..add(const SizedBox(height: AppSpacing.size12))
        ..add(
          ExternalLinkTile(
            linkReference: link,
            variant: variant,
          ),
        );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  bool _shouldKeepContactLink(LinkReference link) => link.label.value.fold(
    (_) => true,
    (label) => label.toLowerCase() != 'portfolio',
  );
}
