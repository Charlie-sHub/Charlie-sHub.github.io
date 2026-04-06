import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'public link schema policy',
    () {
      test(
        'requires https URL patterns across schema-backed public link fields',
        () {
          const expectedPattern = r'^[Hh][Tt][Tt][Pp][Ss]://[^\r\n]+$';
          final projectSchema = _readSchema('schemas/project.schema.json');
          final caseStudySchema = _readSchema('schemas/case_study.schema.json');
          final certificateSchema = _readSchema(
            'schemas/certificate.schema.json',
          );
          final courseSchema = _readSchema('schemas/course.schema.json');
          final resumeSchema = _readSchema('schemas/resume.schema.json');
          final projectDefs = projectSchema[r'$defs'] as Map<String, dynamic>;
          final projectLinkItem =
              projectDefs['link_item'] as Map<String, dynamic>;
          final projectLinkProperties =
              projectLinkItem['properties'] as Map<String, dynamic>;
          final caseStudyDefs =
              caseStudySchema[r'$defs'] as Map<String, dynamic>;
          final certificateDefs =
              certificateSchema[r'$defs'] as Map<String, dynamic>;
          final courseDefs = courseSchema[r'$defs'] as Map<String, dynamic>;
          final resumeDefs = resumeSchema[r'$defs'] as Map<String, dynamic>;

          expect(
            (projectLinkProperties['url'] as Map<String, dynamic>)['pattern'],
            expectedPattern,
          );
          expect(
            (caseStudyDefs['url_string'] as Map<String, dynamic>)['pattern'],
            expectedPattern,
          );
          expect(
            (certificateDefs['url_string'] as Map<String, dynamic>)['pattern'],
            expectedPattern,
          );
          expect(
            (courseDefs['url_string'] as Map<String, dynamic>)['pattern'],
            expectedPattern,
          );
          expect(
            (resumeDefs['url_string'] as Map<String, dynamic>)['pattern'],
            expectedPattern,
          );
        },
      );
    },
  );
}

Map<String, dynamic> _readSchema(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
