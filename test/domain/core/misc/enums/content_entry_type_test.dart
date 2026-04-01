import 'package:charlie_shub_portfolio/domain/core/misc/enums/content_entry_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ContentEntryType',
    () {
      test(
        'maps every schema-backed json type value',
        () {
          expect(
            ContentEntryType.values.map((value) => value.jsonValue),
            <String>[
              'about_me',
              'case_study',
              'certificate',
              'course',
              'project',
              'resume',
            ],
          );
        },
      );

      test(
        'parses known content type strings',
        () {
          expect(
            ContentEntryType.fromString('project'),
            ContentEntryType.project,
          );
          expect(
            ContentEntryType.fromString('case_study'),
            ContentEntryType.caseStudy,
          );
        },
      );

      test(
        'returns null for unknown content type strings',
        () {
          expect(ContentEntryType.fromString('projects'), isNull);
        },
      );
    },
  );
}
