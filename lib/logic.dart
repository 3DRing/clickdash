import 'dart:async';
import 'dart:math';

class Bird {
  final BirdType type;

  const Bird(this.type);
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

class AppState {
  static const AppState initState = AppState(birds: [Bird(BirdType.constant)]);

  final List<Bird> birds;

  const AppState({this.birds = const []});

  AppState copyWith({
    List<Bird> birds,
  }) {
    return AppState(
      birds: birds ?? this.birds,
    );
  }
}

class Store {
  AppState state;
  final _controller = StreamController<AppState>.broadcast();

  Stream<AppState> get changes => _controller.stream;

  Store(this.state);

  void buyBird(BirdType type) {
    final newBirds = [...state.birds];
    newBirds.add(Bird(type));
    state = state.copyWith(birds: newBirds);
    _controller.add(state);
  }
}
