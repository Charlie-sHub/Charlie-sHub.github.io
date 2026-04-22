import 'package:charlie_shub_portfolio/presentation/core/utils/browser_facing_asset_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'resolveBrowserFacingAssetUrl',
    () {
      test(
        'keeps canonical repo asset paths unchanged outside Flutter Web',
        () {
          expect(
            resolveBrowserFacingAssetUrl(
              'assets/documents/resume/carlos_mendez_dev.pdf',
              isWeb: false,
            ),
            'assets/documents/resume/carlos_mendez_dev.pdf',
          );
        },
      );

      test(
        'maps canonical repo asset paths to the emitted Flutter Web asset tree',
        () {
          expect(
            resolveBrowserFacingAssetUrl(
              'assets/documents/resume/carlos_mendez_dev.pdf',
              isWeb: true,
              baseUri: Uri.parse('https://portfolio.example/'),
            ),
            'https://portfolio.example/assets/assets/documents/resume/'
            'carlos_mendez_dev.pdf',
          );
        },
      );

      test(
        'respects the current base URI when resolving browser-facing '
        'asset URLs',
        () {
          expect(
            resolveBrowserFacingAssetUrl(
              'assets/media/content/about/about_me/profile_summary.png',
              isWeb: true,
              baseUri: Uri.parse('https://portfolio.example/site/'),
            ),
            'https://portfolio.example/site/assets/assets/media/content/about/'
            'about_me/profile_summary.png',
          );
        },
      );

      test(
        'leaves non-asset URLs untouched on Flutter Web',
        () {
          expect(
            resolveBrowserFacingAssetUrl(
              'https://example.com/resume.pdf',
              isWeb: true,
              baseUri: Uri.parse('https://portfolio.example/'),
            ),
            'https://example.com/resume.pdf',
          );
        },
      );
    },
  );
}
