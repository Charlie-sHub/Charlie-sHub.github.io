import 'package:charlie_shub_portfolio/domain/core/entities/link_reference.dart';
import 'package:charlie_shub_portfolio/domain/core/misc/enums/link_reference_kind.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/url_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'LinkReference',
    () {
      test(
        'is valid when label and url are valid',
        () {
          final link = LinkReference(
            label: SingleLineText('Credly badge'),
            url: UrlValue('https://www.credly.com/badges/example'),
          );

          expect(link.isValid, isTrue);
          expect(link.failureOption.isNone(), isTrue);
          expect(link.kind, LinkReferenceKind.external);
        },
      );

      test(
        'exposes nested url failures',
        () {
          final link = LinkReference(
            label: SingleLineText('Credly badge'),
            url: UrlValue('/badges/example'),
          );

          expect(link.isValid, isFalse);
          expect(link.failureOption.isSome(), isTrue);
        },
      );

      test(
        'stores explicit link semantics when provided',
        () {
          final link = LinkReference(
            label: SingleLineText('GitHub'),
            url: UrlValue('https://github.com/example'),
            kind: LinkReferenceKind.github,
          );

          expect(link.kind, LinkReferenceKind.github);
          expect(link.isValid, isTrue);
        },
      );
    },
  );
}
