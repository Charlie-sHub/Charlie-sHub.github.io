import 'package:charlie_shub_portfolio/domain/core/entities/course_details.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'CourseDetails',
    () {
      test(
        'is valid for required detail fields',
        () {
          final details = CourseDetails(
            provider: SingleLineText('Google'),
            platform: SingleLineText('Coursera'),
            format: SingleLineText('multi-module online course'),
            level: SingleLineText('foundational'),
          );

          expect(details.isValid, isTrue);
        },
      );

      test(
        'is invalid when a required field is invalid',
        () {
          final details = CourseDetails(
            provider: SingleLineText('Google'),
            platform: SingleLineText('Coursera'),
            format: SingleLineText('   '),
            level: SingleLineText('foundational'),
          );

          expect(details.isValid, isFalse);
          expect(details.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
