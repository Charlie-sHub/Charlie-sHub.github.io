import 'package:charlie_shub_portfolio/domain/core/entities/project_link_or_media.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/asset_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ProjectLinkOrMedia',
    () {
      test(
        'supports asset-backed references',
        () {
          final item = ProjectLinkOrMedia.asset(
            label: SingleLineText('Architecture diagram'),
            assetPath: AssetPath(
              'assets/media/content/projects/pami/diagram.png',
            ),
          );

          expect(item.isValid, isTrue);
          expect(item.failureOrUnit.isRight(), isTrue);
        },
      );

      test(
        'exposes invalid external urls',
        () {
          final item = ProjectLinkOrMedia.external(
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
