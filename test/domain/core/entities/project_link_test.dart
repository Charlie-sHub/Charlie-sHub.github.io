import 'package:charlie_shub_portfolio/domain/core/entities/project_link.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ProjectLink',
    () {
      test(
        'supports external project links',
        () {
          final item = ProjectLink(
            label: SingleLineText('GitHub'),
            url: UrlValue('https://github.com/Charlie-sHub'),
          );

          expect(item.isValid, isTrue);
          expect(item.failureOrUnit.isRight(), isTrue);
        },
      );

      test(
        'exposes invalid urls',
        () {
          final item = ProjectLink(
            label: SingleLineText('Demo'),
            url: UrlValue('/demo'),
          );

          expect(item.isValid, isFalse);
          expect(item.failureOption.isSome(), isTrue);
          expect(item.failureOrUnit.isLeft(), isTrue);
        },
      );
    },
  );
}
