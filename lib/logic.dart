import 'dart:math';

class Bird {
  final BirdType type;

  Bird(this.type);
}

enum BirdType {
  constant,
  random,
}

class BirdCalc {
  static const _minRandomValue = 1;
  static const _maxRandomValue = 50;

  final Random random;

  const BirdCalc(this.random);

  int getTransaction(Bird bird) {
    switch (bird.type) {
      case BirdType.constant:
        return 1;
      case BirdType.random:
        return random.nextInt(_maxRandomValue) + _minRandomValue;
    }
    return 0;
  }
}
