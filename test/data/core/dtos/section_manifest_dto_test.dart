import 'package:charlie_shub_portfolio/data/core/dtos/section_manifest_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

void main() {
  group(
    'SectionManifestDto',
    () {
      test(
        'parses lightweight manifest items with optional order',
        () {
          final manifest = SectionManifestDto.fromJson(
            <String, dynamic>{
              'items': <Map<String, dynamic>>[
                <String, dynamic>{
                  'file': 'world_on.json',
                  'order': 2,
                },
                <String, dynamic>{
                  'file': 'pami.json',
                },
              ],
            },
          );

          expect(manifest.items, hasLength(2));
          expect(manifest.items.first.file, 'world_on.json');
          expect(manifest.items.first.order, 2);
          expect(manifest.items.last.file, 'pami.json');
          expect(manifest.items.last.order, isNull);
        },
      );

      test(
        'rejects unsupported rich metadata fields',
        () {
          expect(
            () => SectionManifestDto.fromJson(
              <String, dynamic>{
                'items': <Map<String, dynamic>>[
                  <String, dynamic>{
                    'file': 'about_me.json',
                    'title': 'About Me',
                  },
                ],
              },
            ),
            throwsA(isA<CheckedFromJsonException>()),
          );
        },
      );

      test(
        'rejects non-integer order values',
        () {
          expect(
            () => SectionManifestDto.fromJson(
              <String, dynamic>{
                'items': <Map<String, dynamic>>[
                  <String, dynamic>{
                    'file': 'about_me.json',
                    'order': 'first',
                  },
                ],
              },
            ),
            throwsA(isA<CheckedFromJsonException>()),
          );
        },
      );
    },
  );
}
