import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
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
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.error),
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.errorContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Text(
          'Invalid content: ${failure.message}',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}
