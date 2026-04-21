import 'package:charlie_shub_portfolio/domain/core/validation/objects/email_address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'EmailAddress',
    () {
      test(
        'accepts a valid single-line email address',
        () {
          final emailAddress = EmailAddress('carlosrafael-mg@hotmail.com');

          expect(emailAddress.isValid(), isTrue);
          expect(
            emailAddress.getOrCrash(),
            'carlosrafael-mg@hotmail.com',
          );
        },
      );

      test(
        'rejects invalid email input',
        () {
          final emailAddress = EmailAddress('not-an-email');

          expect(emailAddress.isValid(), isFalse);
          expect(emailAddress.failureOrNull, isNotNull);
        },
      );
    },
  );
}
