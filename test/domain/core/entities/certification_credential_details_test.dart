import 'package:charlie_shub_portfolio/domain/core/entities/certification_credential_details.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'CertificationCredentialDetails',
    () {
      test(
        'is valid for required credential detail fields',
        () {
          final details = CertificationCredentialDetails(
            issuer: SingleLineText('CompTIA'),
            credentialType: SingleLineText('cybersecurity certification'),
            level: SingleLineText('entry to intermediate'),
          );

          expect(details.isValid, isTrue);
        },
      );

      test(
        'is invalid when a required field is invalid',
        () {
          final details = CertificationCredentialDetails(
            issuer: SingleLineText('CompTIA'),
            credentialType: SingleLineText('   '),
            level: SingleLineText('entry to intermediate'),
          );

          expect(details.isValid, isFalse);
          expect(details.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
