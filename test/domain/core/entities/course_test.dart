import 'package:charlie_shub_portfolio/domain/core/entities/course.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/course_details.dart';
import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/document_path.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/slug.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Course',
    () {
      test(
        'is valid for a schema-aligned course shape',
        () {
          final course = Course(
            slug: Slug('google_networking'),
            sourcePath: SingleLineText(
              'knowledge/courses/google_networking.md',
            ),
            title: Title('The Bits and Bytes of Computer Networking'),
            summary: NonEmptyText('Foundational networking course from Google'),
            certificatePdfPath: DocumentPath(
              'assets/documents/courses/google_networking.pdf',
            ),
            courseDetails: CourseDetails(
              provider: SingleLineText('Google'),
              platform: SingleLineText('Coursera'),
              format: SingleLineText('multi-module online course'),
              level: SingleLineText('foundational'),
            ),
            topicsCovered: <NonEmptyText>[
              NonEmptyText('Introduction to networking'),
            ],
            relevance: <NonEmptyText>[
              NonEmptyText('Helps interpret attack paths'),
            ],
            proof: <LinkReference>[
              LinkReference(
                label: SingleLineText('Course page'),
                url: UrlValue(
                  'https://www.coursera.org/learn/computer-networking',
                ),
              ),
            ],
          );

          expect(course.isValid, isTrue);
        },
      );

      test(
        'is invalid when nested details contain invalid text',
        () {
          final course = Course(
            slug: Slug('google_networking'),
            sourcePath: SingleLineText(
              'knowledge/courses/google_networking.md',
            ),
            title: Title('The Bits and Bytes of Computer Networking'),
            summary: NonEmptyText('Foundational networking course from Google'),
            courseDetails: CourseDetails(
              provider: SingleLineText('Google'),
              platform: SingleLineText('Coursera'),
              format: SingleLineText('   '),
              level: SingleLineText('foundational'),
            ),
            topicsCovered: <NonEmptyText>[
              NonEmptyText('Introduction to networking'),
            ],
            relevance: <NonEmptyText>[
              NonEmptyText('Helps interpret attack paths'),
            ],
          );

          expect(course.isValid, isFalse);
          expect(course.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
