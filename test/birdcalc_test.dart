import 'dart:math';

import 'package:clickdash/logic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

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

  test('when single combo bird type then transaction is 1', () {
    final random = Random();
    final calc = BirdCalc(random);
    final bird = Bird(BirdType.combo);

    final result = calc.getTransaction(bird, birds: [Bird(BirdType.combo)]);

    expect(result, 5);
  });

  test('when many combo birds then transaction is bigger each time', () {
    final random = Random();
    final calc = BirdCalc(random);
    final bird = Bird(BirdType.combo);

    var result = calc.getTransaction(bird,
        birds: [Bird(BirdType.combo), Bird(BirdType.constant)]);

    expect(result, 5);

    result = calc.getTransaction(bird, birds: [
      Bird(BirdType.combo),
      Bird(BirdType.constant),
      Bird(BirdType.random),
    ]);

    expect(result, 5);

    result = calc.getTransaction(bird, birds: [
      Bird(BirdType.combo),
      Bird(BirdType.constant),
      Bird(BirdType.random),
      Bird(BirdType.combo),
    ]);

    expect(result, 10);

    result = calc.getTransaction(bird, birds: [
      Bird(BirdType.combo),
      Bird(BirdType.constant),
      Bird(BirdType.random),
      Bird(BirdType.combo),
      Bird(BirdType.combo),
    ]);

    expect(result, 15);
  });
}
