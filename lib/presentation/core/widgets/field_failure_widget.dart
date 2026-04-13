import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_radii.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_spacing.dart';
import 'package:charlie_shub_portfolio/presentation/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Displays a field-level validation failure in the presentation layer.
class FieldFailureWidget extends StatelessWidget {
  /// Creates a field failure widget.
  const FieldFailureWidget({
    required this.failure,
    super.key,
  });

  /// The validation failure to show.
  final ValueFailure<dynamic> failure;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.error,
          width: 1.2,
        ),
        borderRadius: AppRadii.feedback,
        color: colorScheme.errorContainer,
      ),
      child: Padding(
        padding: AppSpacing.fieldFailurePadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.report_gmailerrorred_outlined,
              size: 18,
              color: colorScheme.error,
            ),
            const SizedBox(width: AppSpacing.size8),
            Expanded(
              child: Text(
                'Invalid content: ${failure.message}',
                style: AppTextStyles.supporting(context)?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
