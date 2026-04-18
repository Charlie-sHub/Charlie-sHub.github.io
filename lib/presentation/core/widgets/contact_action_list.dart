import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/external_link_tile.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

const _directEmailAddress = 'carlosrafael-mg@hotmail.com';

/// Shared layout arrangements for contact action groups.
enum ContactActionLayout {
  /// Stacked full-width buttons used in narrower summary surfaces.
  stacked,

  /// Row-first layout used for wider resume-style contact groups.
  row,
}

/// Renders the shared portfolio contact actions used by profile surfaces.
class ContactActionList extends StatelessWidget {
  /// Creates a contact action list.
  const ContactActionList({
    required this.links,
    this.collectionFailure,
    this.variant = ActionLinkVariant.contactButton,
    this.layout = ContactActionLayout.stacked,
    super.key,
  });

  /// Structured contact links sourced from the resume content.
  final List<LinkReference> links;

  /// The collection-level validation failure to render, if any.
  final ValueFailure<dynamic>? collectionFailure;

  /// The button treatment used for the rendered contact actions.
  final ActionLinkVariant variant;

  /// The preferred layout arrangement for the rendered contact actions.
  final ContactActionLayout layout;

  @override
  Widget build(BuildContext context) {
    if (collectionFailure != null) {
      return FieldFailureWidget(
        failure: collectionFailure!,
      );
    }

    final visibleLinks = links.where(_shouldKeepContactLink).toList();
    final actions = <Widget>[
      ActionLinkTile(
        label: 'Email',
        url: 'mailto:$_directEmailAddress',
        actionLabel: 'Write',
        leadingIcon: Icons.mail_outline_rounded,
        variant: variant,
      ),
    ];

    for (final link in visibleLinks) {
      actions.add(
        ExternalLinkTile(
          linkReference: link,
          variant: variant,
        ),
      );
    }

    if (layout == ContactActionLayout.row) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= AppLayout.contactActionRowBreakpoint) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < actions.length; index++) ...[
                  Expanded(
                    child: actions[index],
                  ),
                  if (index < actions.length - 1)
                    const SizedBox(width: AppSpacing.size12),
                ],
              ],
            );
          }

          return _buildStackedActions(actions);
        },
      );
    }

    return _buildStackedActions(actions);
  }

  bool _shouldKeepContactLink(LinkReference link) => link.label.value.fold(
    (_) => true,
    (label) => label.toLowerCase() != 'portfolio',
  );

  Widget _buildStackedActions(List<Widget> actions) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var index = 0; index < actions.length; index++) ...[
        SizedBox(
          width: double.infinity,
          child: actions[index],
        ),
        if (index < actions.length - 1)
          const SizedBox(height: AppSpacing.size12),
      ],
    ],
  );
}
