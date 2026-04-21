import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_button_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/contact/link_button.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

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
        icon: leadingIcon ?? iconForLinkKind(linkReference.kind),
        size: size,
      ),
    ),
  );
}
