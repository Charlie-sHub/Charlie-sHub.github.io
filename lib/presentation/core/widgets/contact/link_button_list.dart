import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_button_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/contact/validated_link_button.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Renders a vertical list of validated link buttons.
class LinkButtonList extends StatelessWidget {
  /// Creates a link button list.
  const LinkButtonList({
    required this.links,
    this.collectionFailure,
    this.onLinkTap,
    this.size = LinkButtonSize.standard,
    super.key,
  });

  /// The validated links to render.
  final List<LinkReference> links;

  /// The collection-level validation failure to render, if any.
  final ValueFailure<dynamic>? collectionFailure;

  /// The optional tap callback for each link.
  final void Function(LinkReference link)? onLinkTap;

  /// Shared size treatment for the rendered buttons.
  final LinkButtonSize size;

  @override
  Widget build(BuildContext context) {
    if (collectionFailure != null) {
      return FieldFailureWidget(
        failure: collectionFailure!,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < links.length; index++) ...[
          SizedBox(
            width: double.infinity,
            child: ValidatedLinkButton(
              linkReference: links[index],
              onTap: onLinkTap == null ? null : () => onLinkTap!(links[index]),
              size: size,
            ),
          ),
          if (index < links.length - 1)
            const SizedBox(height: AppSpacing.size12),
        ],
      ],
    );
  }
}
