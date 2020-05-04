import 'dart:math';

import 'package:clickdash/logic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('when const bird type then transaction is constant', () {
    // arrange
    final random = Random();
    final calc = BirdCalc(random);

    // act
    final result = calc.getTransaction(Bird(BirdType.constant));

    // assert
    expect(result, 1);
  });

  test('when random bird type then transaction is dependant on random', () {
    // arrange
    final random = MockRandom();
    final calc = BirdCalc(random);

    var counter = 0;
    when(random.nextInt(50)).thenAnswer((_) => counter++);

    // act
    var result = calc.getTransaction(Bird(BirdType.random));

    // assert
    expect(result, 1);

    result = calc.getTransaction(Bird(BirdType.random));

    // assert
    expect(result, 2);

    verify(random.nextInt(50)).called(2);
  });
}

class MockRandom extends Mock implements Random {}