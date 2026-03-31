// ignore_for_file: inference_failure_on_function_invocation, document_ignores

import 'package:charlie_shub_portfolio/domain/core/failures/value_failure.dart';
import 'package:charlie_shub_portfolio/domain/core/validation/objects/value_object.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ValueObject',
    () {
      test(
        'failureOrUnit returns unit for valid values',
        () {
          final valueObject = _TestValueObject.valid('portfolio');

          expect(valueObject.failureOrUnit, right(unit));
          expect(valueObject.isValid(), isTrue);
        },
      );

      test(
        'failureOrUnit returns the failure for invalid values',
        () {
          final valueObject = _TestValueObject.invalid('   ');

          expect(
            valueObject.failureOrUnit,
            left<ValueFailure<dynamic>, Unit>(
              const ValueFailure<String>.emptyString(failedValue: '   '),
            ),
          );
          expect(valueObject.isValid(), isFalse);
          expect(
            valueObject.failureOrNull,
            const ValueFailure<String>.emptyString(failedValue: '   '),
          );
        },
      );

      test(
        'getOrCrash returns the underlying valid value',
        () {
          final valueObject = _TestValueObject.valid('trusted');

          expect(valueObject.getOrCrash(), 'trusted');
          expect(valueObject.toString(), 'trusted');
        },
      );

      test(
        'getOrCrash throws UnexpectedValueError for invalid values',
        () {
          final valueObject = _TestValueObject.invalid('');

          expect(
            valueObject.getOrCrash,
            throwsA(
              isA<UnexpectedValueError>().having(
                (error) => error.valueFailure,
                'valueFailure',
                const ValueFailure<String>.emptyString(failedValue: ''),
              ),
            ),
          );
        },
      );

      test(
        'value objects compare by runtime type and value',
        () {
          final first = _TestValueObject.valid('same');
          final second = _TestValueObject.valid('same');
          final different = _OtherTestValueObject.valid('same');

          expect(first, second);
          expect(first.hashCode, second.hashCode);
          expect(first == different, isFalse);
        },
      );
    },
  );
}

final class _TestValueObject extends ValueObject<String> {
  const _TestValueObject._(this.value);

  factory _TestValueObject.valid(String input) => _TestValueObject._(
    Right(input),
  );

  factory _TestValueObject.invalid(String input) => _TestValueObject._(
    Left(ValueFailure.emptyString(failedValue: input)),
  );

  @override
  final Either<ValueFailure<String>, String> value;
}

final class _OtherTestValueObject extends ValueObject<String> {
  const _OtherTestValueObject._(this.value);

  factory _OtherTestValueObject.valid(String input) => _OtherTestValueObject._(
    Right(input),
  );

  @override
  final Either<ValueFailure<String>, String> value;
}
