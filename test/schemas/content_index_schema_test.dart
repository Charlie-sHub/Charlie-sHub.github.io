import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'content_index.schema.json',
    () {
      test(
        'defines a lightweight manifest item contract',
        () {
          final schema =
              jsonDecode(
                    File(
                      'schemas/content_index.schema.json',
                    ).readAsStringSync(),
                  )
                  as Map<String, dynamic>;
          final definitions = schema[r'$defs'] as Map<String, dynamic>;
          final item = definitions['item'] as Map<String, dynamic>;
          final properties = item['properties'] as Map<String, dynamic>;

          expect(item['additionalProperties'], isFalse);
          expect(item['required'], <String>['file']);
          expect(properties.keys, <String>['file', 'order']);
        },
      );
    },
  );
}
