import 'package:charlie_shub_portfolio/domain/core/entities/resume_experience_item.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/non_empty_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/single_line_text.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/title.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/year_month.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ResumeExperienceItem',
    () {
      test(
        'is valid with required fields and highlights',
        () {
          final item = ResumeExperienceItem(
            title: Title('Software Developer'),
            organization: SingleLineText('Media Mechanics'),
            location: SingleLineText('Halifax, Canada'),
            startDate: YearMonth('2021-06'),
            endDate: YearMonth('2024-10'),
            isOngoing: false,
            highlights: <NonEmptyText>[
              NonEmptyText('Built Flutter applications'),
            ],
          );

          expect(item.isValid, isTrue);
        },
      );

      test(
        'is invalid when highlights are empty',
        () {
          final item = ResumeExperienceItem(
            title: Title('Software Developer'),
            location: SingleLineText('Halifax, Canada'),
            startDate: YearMonth('2021-06'),
            endDate: YearMonth('2024-10'),
            isOngoing: false,
            highlights: const <NonEmptyText>[],
          );

          expect(item.isValid, isFalse);
          expect(item.failureOption.isSome(), isTrue);
        },
      );
    },
  );
}
