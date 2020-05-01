import 'package:clickdash/logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('when const bird type then transaction is constant', () {
    // arrange
    final calc = BirdCalc();
    final bird = Bird(BirdType.constant);

    // act
    final result = calc.getTransaction(bird);

    // assert
    expect(result, 1);
  });
}
