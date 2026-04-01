import 'package:charlie_shub_portfolio/domain/core/failures/app_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'AppFailure',
    () {
      test(
        'supports equality for the same application failure',
        () {
          const first = AppFailure.assetNotFound(
            path: 'assets/content/projects/missing.json',
          );
          const second = AppFailure.assetNotFound(
            path: 'assets/content/projects/missing.json',
          );

          expect(first, second);
        },
      );

      test(
        'keeps the path and error string for content load errors',
        () {
          const failure = AppFailure.contentLoadError(
            path: 'assets/content/projects/index.json',
            errorString: 'Unsupported JSON shape',
          );

          final details = switch (failure) {
            ContentLoadError(:final path, :final errorString) => (
              path: path,
              errorString: errorString,
            ),
            _ => null,
          };

          expect(details?.path, 'assets/content/projects/index.json');
          expect(details?.errorString, 'Unsupported JSON shape');
          expect(
            failure.message,
            'Failed to load content from assets/content/projects/index.json: '
            'Unsupported JSON shape',
          );
        },
      );

      test(
        'describes missing assets clearly',
        () {
          const failure = AppFailure.assetNotFound(
            path: 'assets/media/content/projects/world_on/hero.png',
          );

          expect(
            failure.message,
            'Asset was not found at '
            'assets/media/content/projects/world_on/hero.png.',
          );
        },
      );

      test(
        'describes media load failures clearly',
        () {
          const failure = AppFailure.mediaLoadError(
            path: 'assets/media/content/projects/world_on/hero.png',
            errorString: 'Decoding failed',
          );

          expect(
            failure.message,
            'Failed to load media from '
            'assets/media/content/projects/world_on/hero.png: Decoding failed',
          );
        },
      );

      test(
        'describes document open failures clearly',
        () {
          const failure = AppFailure.documentOpenError(
            path: 'assets/documents/resume/resume.pdf',
            errorString: 'Browser blocked the request',
          );

          expect(
            failure.message,
            'Failed to open document at assets/documents/resume/resume.pdf: '
            'Browser blocked the request',
          );
        },
      );

      test(
        'describes unexpected failures clearly',
        () {
          const failure = AppFailure.unexpectedError(
            errorString: 'Unknown runtime exception',
          );

          expect(
            failure.message,
            'An unexpected error occurred: Unknown runtime exception',
          );
        },
      );
    },
  );
}
