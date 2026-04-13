import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Renders a reusable section heading.
class SectionHeadingText extends StatelessWidget {
  /// Creates a section heading text widget.
  const SectionHeadingText({
    required this.text,
    super.key,
  });

  /// The heading text to display.
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.sectionHeading(context),
  );
}

/// Renders a reusable content heading.
class HeadingText extends StatelessWidget {
  /// Creates a content heading text widget.
  const HeadingText({
    required this.text,
    super.key,
  });

  /// The heading text to display.
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.heading(context),
  );
}

/// Renders reusable body copy.
class BodyText extends StatelessWidget {
  /// Creates a body text widget.
  const BodyText({
    required this.text,
    super.key,
  });

  /// The body text to display.
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.body(context),
  );
}

/// Renders reusable supporting text.
class SupportingText extends StatelessWidget {
  /// Creates a supporting text widget.
  const SupportingText({
    required this.text,
    super.key,
  });

  /// The supporting text to display.
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.supporting(context),
  );
}
