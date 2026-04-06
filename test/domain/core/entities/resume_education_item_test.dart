import 'package:charlie_shub_portfolio/domain/core/entities/resume_education_item.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ResumeEducationItem',
    () {
      test(
        'is valid with required fields',
        () {
          final item = ResumeEducationItem(
            title: Title(
              'Higher Technician in Multiplatform Application Development',
            ),
            institution: SingleLineText('CIFP Tartanga'),
            location: SingleLineText('Erandio, Spain'),
            startDate: YearMonth('2018-09'),
            endDate: YearMonth('2020-05'),
          );

          expect(item.isValid, isTrue);
        },
      );

      test(
        'is invalid when a required field is invalid',
        () {
          final item = ResumeEducationItem(
            title: Title('   '),
            institution: SingleLineText('CIFP Tartanga'),
            location: SingleLineText('Erandio, Spain'),
            startDate: YearMonth('2018-09'),
            endDate: YearMonth('2020-05'),
          );

          expect(item.isValid, isFalse);
          expect(item.failureOption.isSome(), isTrue);
        },
      );

      test(
        'is invalid when the education end date is earlier than the start date',
        () {
          final item = ResumeEducationItem(
            title: Title(
              'Higher Technician in Multiplatform Application Development',
            ),
            institution: SingleLineText('CIFP Tartanga'),
            location: SingleLineText('Erandio, Spain'),
            startDate: YearMonth('2020-05'),
            endDate: YearMonth('2018-09'),
          );

          expect(item.isValid, isFalse);
          expect(item.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
