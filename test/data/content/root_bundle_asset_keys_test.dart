import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Flutter asset bundle configuration',
    () {
      test(
        'loads repo assets with canonical logical keys',
        () async {
          final aboutIndex = await rootBundle.loadString(
            'assets/content/about/index.json',
          );
          final profileImage = await rootBundle.load(
            'assets/media/content/about/about_me/profile_summary.png',
          );
          final projectImage = await rootBundle.load(
            'assets/media/content/projects/world_on/world_on_login.png',
          );
          final resumePdf = await rootBundle.load(
            'assets/documents/resume/carlos_mendez_dev.pdf',
          );

          expect(aboutIndex, contains('"file": "about_me.json"'));
          expect(profileImage.lengthInBytes, greaterThan(0));
          expect(projectImage.lengthInBytes, greaterThan(0));
          expect(resumePdf.lengthInBytes, greaterThan(0));
        },
      );

      test(
        'does not use duplicated assets prefixes in logical keys',
        () async {
          await expectLater(
            rootBundle.loadString('assets/assets/content/about/index.json'),
            throwsA(isA<FlutterError>()),
          );
        },
      );
    },
  );
}
