import 'package:charlie_shub_portfolio/domain/core/validation/objects/email_address.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_button_styles.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/contact/link_button.dart';
import 'package:charlie_shub_portfolio/presentation/core/widgets/field_failure_widget.dart';
import 'package:flutter/material.dart';

/// Validates a direct-contact email address before rendering a mail button.
class ValidatedEmailLinkButton extends StatelessWidget {
  /// Creates a validated email link button.
  const ValidatedEmailLinkButton({
    required this.emailAddress,
    this.onTap,
    this.size = LinkButtonSize.standard,
    super.key,
  });

  /// The email address to render as a direct contact action.
  final EmailAddress emailAddress;

  /// Optional tap override used mainly in tests.
  final VoidCallback? onTap;

  /// Shared size treatment for the rendered button.
  final LinkButtonSize size;

  @override
  Widget build(BuildContext context) => emailAddress.value.fold(
    (failure) => FieldFailureWidget(
      failure: failure,
    ),
    (value) => LinkButton(
      label: 'Email',
      onTap: onTap,
      url: 'mailto:$value',
      icon: Icons.mail_outline_rounded,
      size: size,
    ),
  );
}
