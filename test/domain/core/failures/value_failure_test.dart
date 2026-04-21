import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ValueFailure',
    () {
      test(
        'supports equality for the same validation failure',
        () {
          const first = ValueFailure<String>.invalidSlug(
            failedValue: 'not-valid',
          );
          const second = ValueFailure<String>.invalidSlug(
            failedValue: 'not-valid',
          );

          expect(first, second);
        },
      );

      test(
        'keeps the failed value for invalid year-month data',
        () {
          const failure = ValueFailure<String>.invalidYearMonth(
            failedValue: '2026/03',
          );

          final failedValue = switch (failure) {
            InvalidYearMonth<String>(:final failedValue) => failedValue,
            _ => null,
          };

          expect(failedValue, '2026/03');
          expect(failure.message, 'Date must use the YYYY-MM format.');
        },
      );

      test(
        'describes collection size failures clearly',
        () {
          const failure = ValueFailure<List<String>>.collectionTooShort(
            failedValue: <String>[],
            minLength: 1,
          );

          expect(
            failure.message,
            'Collection must contain at least 1 item.',
          );
        },
      );

      test(
        'describes multiline string failures clearly',
        () {
          const failure = ValueFailure<String>.multilineString(
            failedValue: 'About\nMe',
          );

          expect(
            failure.message,
            'String must not contain line breaks.',
          );
        },
      );

      test(
        'describes max length failures clearly',
        () {
          const failure = ValueFailure<String>.stringExceedsLength(
            failedValue: 'A very long title',
            maxLength: 10,
          );

          expect(
            failure.message,
            'String must not exceed 10 characters.',
          );
        },
      );

      test(
        'describes invalid document paths clearly',
        () {
          const failure = ValueFailure<String>.invalidDocumentPath(
            failedValue: 'assets/media/resume.pdf',
          );

          expect(
            failure.message,
            'Document path must start with assets/documents/.',
          );
        },
      );

      test(
        'describes invalid email addresses clearly',
        () {
          const failure = ValueFailure<String>.invalidEmailAddress(
            failedValue: 'not-an-email',
          );

          expect(
            failure.message,
            'Email address must be a valid single-line email.',
          );
        },
      );

      test(
        'describes invalid resume language proficiency clearly',
        () {
          const failure = ValueFailure<String>.invalidResumeLanguageProficiency(
            failedValue: 'invalid',
          );

          expect(
            failure.message,
            'Resume language proficiency must match a supported value.',
          );
        },
      );

      test(
        'describes timeline validation failures clearly',
        () {
          const endDateBeforeStartDate =
              ValueFailure<String>.endDatePrecedesStartDate(
                failedValue: '2025-03->2025-02',
              );
          const ongoingTimelineHasEndDate =
              ValueFailure<String>.ongoingTimelineHasEndDate(
                failedValue: '2025-01->2025-02',
              );
          const completedTimelineMissingEndDate =
              ValueFailure<String>.completedTimelineMissingEndDate(
                failedValue: '2025-01',
              );

          expect(
            endDateBeforeStartDate.message,
            'End date must not be earlier than start date.',
          );
          expect(
            ongoingTimelineHasEndDate.message,
            'Ongoing entries must not define an end date.',
          );
          expect(
            completedTimelineMissingEndDate.message,
            'Completed entries must define an end date.',
          );
        },
      );
    },
  );
}
