import 'dart:math';

import 'package:clickdash/logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('when const bird type then transaction is constant', () {
    // arrange
    final random = Random();
    final calc = BirdCalc(random);
    final bird = Bird(BirdType.constant);

    // act
    final result = calc.getTransaction(bird);

    // assert
    expect(result, 1);
  });

  test('when random bird type then transaction is dependant on random', () {
    final random = Random(1);
    final calc = BirdCalc(random);
    final bird = Bird(BirdType.random);
    final expectedResults = [5, 38, 46, 10];

    for (final value in expectedResults) {
      final result = calc.getTransaction(bird);

      expect(result, value);
    }
  });
}
