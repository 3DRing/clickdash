import 'dart:math';

import 'package:clickdash/logic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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
    final random = MockRandom();
    final minRandomValue = 1;
    final maxRandomValue = 50;
    var time = 0;
    final randomValues = [minRandomValue - 1, 4, 29, maxRandomValue - 1];
    when(random.nextInt(maxRandomValue)).thenAnswer((_) {
      return randomValues[time++];
    });

    final calc = BirdCalc(random);
    final bird = Bird(BirdType.random);
    final expectedResults = [minRandomValue, 5, 30, maxRandomValue];

    for (final value in expectedResults) {
      final result = calc.getTransaction(bird);

      expect(result, value);
    }

    verify(random.nextInt(maxRandomValue)).called(4);
  });
}

class MockRandom extends Mock implements Random {}
