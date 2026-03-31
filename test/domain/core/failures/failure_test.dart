import 'package:charlie_shub_portfolio/domain/core/failures/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Failure',
    () {
      test(
        'toString returns the message',
        () {
          const failure = _TestFailure('Something went wrong.');

          expect(failure.message, 'Something went wrong.');
          expect(failure.toString(), 'Something went wrong.');
        },
      );
    },
  );
}

final class _TestFailure extends Failure {
  const _TestFailure(this.message);

  @override
  final String message;
}
