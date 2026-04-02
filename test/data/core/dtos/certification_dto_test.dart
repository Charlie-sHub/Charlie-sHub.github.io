import 'package:charlie_shub_portfolio/data/core/dtos/certification_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dto_test_utils.dart';

void main() {
  group(
    'CertificationDto',
    () {
      test(
        'maps a certification with a document path into domain',
        () {
          final json = loadJsonFixture(
            'assets/content/certifications/google_cybersecurity.json',
          );

          final dto = CertificationDto.fromJson(json);
          final certification = dto.toDomain();

          expect(certification.isValid, isTrue);
          expect(certification.slug.getOrCrash(), 'google_cybersecurity');
          expect(
            certification.certificatePdfPath?.getOrCrash(),
            'assets/documents/certifications/'
            'google_cybersecurity_professional_certificate_v2.pdf',
          );
          expect(certification.badgeImagePath, isNull);
        },
      );

      test(
        'collapses optional proof and tools to empty collections in domain',
        () {
          final json = loadJsonFixture(
            'assets/content/certifications/google_cybersecurity.json',
          );
          (json['content'] as Map<String, dynamic>)
            ..remove('proof')
            ..remove('tools_and_frameworks');

          final dto = CertificationDto.fromJson(json);
          final certification = dto.toDomain();

          expect(certification.proof, isEmpty);
          expect(certification.toolsAndFrameworks, isEmpty);
        },
      );

      test(
        'maps invalid document paths into an invalid domain object',
        () {
          final json = loadJsonFixture(
            'assets/content/certifications/google_cybersecurity.json',
          );
          final content = json['content'] as Map<String, dynamic>;
          content['certificatePdfPath'] = 'assets/media/not-a-document.pdf';

          final dto = CertificationDto.fromJson(json);
          final certification = dto.toDomain();

          expect(certification.isValid, isFalse);
          expect(certification.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
