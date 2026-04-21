import 'package:charlie_shub_portfolio/presentation/core/utils/open_external_resource.dart';
import 'package:charlie_shub_portfolio/presentation/core/utils/open_external_resource_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'openExternalResource helpers',
    () {
      test(
        'keep the retained browser launch target and safety features explicit',
        () {
          expect(externalResourceWindowTarget, '_blank');
          expect(externalResourceWindowFeatures, 'noopener,noreferrer');
        },
      );

      test(
        'resolveOpenExternalResource prefers an explicit tap override',
        () {
          var tapped = false;

          final callback = resolveOpenExternalResource(
            'https://example.com',
            onTap: () => tapped = true,
          );

          callback();

          expect(tapped, isTrue);
        },
      );

      test(
        'resolveOpenExternalResource still returns an invokable callback '
        'without an override',
        () {
          final callback = resolveOpenExternalResource('https://example.com');

          expect(callback, isNotNull);
          expect(callback, returnsNormally);
        },
      );
    },
  );
}
