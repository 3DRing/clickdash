
import 'dart:async';
import 'dart:math';

enum BirdType {
  constant, random,
}

class Bird {
  final BirdType type;

  const Bird(this.type);
}

class BirdCalc {

  final Random random;

  const BirdCalc(this.random);

  int getTransaction(Bird bird) {
    switch(bird.type) {
      case BirdType.constant:
        return 1;
      case BirdType.random:
        return random.nextInt(50) + 1;
    }
    return 0;
  }
}

class BirdItem {
  final BirdType type;
  final int price;

  const BirdItem(this.type, this.price);
}

class AppState {
  static const AppState initState = AppState(
    balance: 0,
    birds: [Bird(BirdType.constant)],
    items: [
      BirdItem(BirdType.constant, 25),
      BirdItem(BirdType.random, 100),
    ],
  );

  final int balance;
  final List<Bird> birds;
  final List<BirdItem> items;

  const AppState({
    this.balance = 0,
    this.birds = const [],
    this.items = const [],
  });

  AppState copyWith({
    int balance,
    List<Bird> birds,
    List<BirdItem> items,
  }) {
    return AppState(
      balance: balance ?? this.balance,
      birds: birds ?? this.birds,
      items: items ?? this.items,
    );
  }
}

class Store {
  AppState state;
  final _controller = StreamController<AppState>.broadcast();
  final BirdCalc calc;

  Stream<AppState> get changes => _controller.stream;

  Store(this.state, this.calc);

  void buyBird(BirdItem item) {
    final newBirds = [...state.birds];
    newBirds.add(Bird(item.type));
    final newBalance = state.balance - item.price;
    state = state.copyWith(balance: newBalance, birds: newBirds);
    _controller.add(state);
  }

  void earn(Bird bird) {
    final newBalance = state.balance + calc.getTransaction(bird);
    state = state.copyWith(balance: newBalance);
    _controller.add(state);
  }
}