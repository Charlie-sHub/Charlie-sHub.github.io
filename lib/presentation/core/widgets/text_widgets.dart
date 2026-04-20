import 'package:charlie_shub_portfolio/presentation/core/theme/app_layout.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Renders a reusable section heading.
class SectionHeadingText extends StatelessWidget {
  /// Creates a section heading text widget.
  const SectionHeadingText({
    required this.text,
    this.icon,
    super.key,
  });

  /// The heading text to display.
  final String text;

  /// Optional leading icon used for top-level section scanning.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final iconData = icon;
    final headingText = Text(
      text,
      style: AppTextStyles.sectionTitle(context),
    );

    if (iconData == null) {
      return headingText;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          size: AppLayout.sectionHeadingIconSize,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: AppSpacing.size8),
        Flexible(child: headingText),
      ],
    );
  }
}

/// Renders reusable supporting text for top-level section-card surfaces.
class SectionSupportingText extends StatelessWidget {
  /// Creates section supporting text.
  const SectionSupportingText({
    required this.text,
    super.key,
  });

  /// The supporting text to display.
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.sectionSubtitle(context),
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
    style: AppTextStyles.contentTitleCompact(context),
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
    style: AppTextStyles.bodySupporting(context),
  );
}
