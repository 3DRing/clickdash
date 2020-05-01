class Bird {
  final BirdType type;

  Bird(this.type);
}

enum BirdType {
  constant,
  random,
}

class BirdCalc {
  int getTransaction(Bird bird) {
    switch(bird.type) {
      case BirdType.constant:
        return 1;
      case BirdType.random:
        break;
    }
    return 0;
  }
}