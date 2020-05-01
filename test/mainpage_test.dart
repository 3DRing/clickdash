import 'dart:math';

import 'package:clickdash/logic.dart';
import 'package:clickdash/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks.dart';

void main() {
  Random random;
  BirdCalc calc;
  Store store;

  setUp(() {
    random = MockRandom();
    calc = BirdCalc(random);
    store = Store(AppState.initState, calc);
  });

  testWidgets('when initialized then store is on the screen', (tester) async {
    await tester.pumpWidget(TestWidget(MainPage(store: store)));
    final birdStoreFinder = find.byType(BirdStoreView);

    expect(birdStoreFinder, findsOneWidget);
  });

  testWidgets('when initialized then items are seen', (tester) async {
    await tester.pumpWidget(TestWidget(MainPage(store: store)));
    final constantBirdItemFinder =
        find.byKey(ValueKey('${BirdStoreView}${BirdType.constant}'));
    final randomBirdItemFinder =
        find.byKey(ValueKey('${BirdStoreView}${BirdType.random}'));

    expect(constantBirdItemFinder, findsOneWidget);
    expect(randomBirdItemFinder, findsOneWidget);
  });

  testWidgets('when initialized then a single constant bird is added',
      (tester) async {
    await tester.pumpWidget(TestWidget(MainPage(store: store)));
    final constantBirdFinder =
        find.byKey(ValueKey('${MainPage}${BirdType.constant}0'));

    expect(constantBirdFinder, findsOneWidget);
  });

  testWidgets('when constant item is clicked then a constant bird is added',
      (tester) async {
    await tester.pumpWidget(TestWidget(MainPage(store: store)));
    final constantBirdItemFinder =
        find.byKey(ValueKey('${BirdStoreView}${BirdType.constant}'));
    final expectedNumberOfBirds = store.state.birds
            .where((bird) => bird.type == BirdType.constant)
            .length +
        1;

    await tester.tap(constantBirdItemFinder);
    await tester.pump();

    final constantBirdsFinder = find.byWidgetPredicate((widget) =>
        widget.key != null &&
        widget.key is ValueKey<String> &&
        (widget.key as ValueKey<String>)
            .value
            .contains('${MainPage}${BirdType.constant}'));

    expect(constantBirdsFinder, findsNWidgets(expectedNumberOfBirds));
  });

  testWidgets('when random item is clicked then a random bird is added',
      (tester) async {
    await tester.pumpWidget(TestWidget(MainPage(store: store)));
    final randomBirdItemFinder =
        find.byKey(ValueKey('${BirdStoreView}${BirdType.random}'));
    final expectedNumberOfBirds =
        store.state.birds.where((bird) => bird.type == BirdType.random).length +
            1;

    await tester.tap(randomBirdItemFinder);
    await tester.pump();

    final randomBirdsFinder = find.byWidgetPredicate((widget) =>
        widget.key != null &&
        widget.key is ValueKey<String> &&
        (widget.key as ValueKey<String>)
            .value
            .contains('${MainPage}${BirdType.random}'));

    expect(randomBirdsFinder, findsNWidgets(expectedNumberOfBirds));
  });

  testWidgets('when all items are clicked many times then many birds are added',
      (tester) async {
    await tester.pumpWidget(TestWidget(MainPage(store: store)));
    final constantBirdItemFinder =
        find.byKey(ValueKey('${BirdStoreView}${BirdType.constant}'));
    final randomBirdItemFinder =
        find.byKey(ValueKey('${BirdStoreView}${BirdType.random}'));
    final expectedNumberOfConstantBirds = store.state.birds
            .where((bird) => bird.type == BirdType.constant)
            .length +
        50;
    final expectedNumberOfRandomBirds =
        store.state.birds.where((bird) => bird.type == BirdType.random).length +
            50;

    for (var i = 0; i < 100; i++) {
      final tapTarget =
          i % 2 == 0 ? constantBirdItemFinder : randomBirdItemFinder;
      await tester.tap(tapTarget);
      await tester.pump();
    }

    final constantBirdsFinder = find.byWidgetPredicate((widget) =>
        widget.key != null &&
        widget.key is ValueKey<String> &&
        (widget.key as ValueKey<String>)
            .value
            .contains('${MainPage}${BirdType.constant}'));
    final randomBirdsFinder = find.byWidgetPredicate((widget) =>
        widget.key != null &&
        widget.key is ValueKey<String> &&
        (widget.key as ValueKey<String>)
            .value
            .contains('${MainPage}${BirdType.random}'));

    expect(constantBirdsFinder, findsNWidgets(expectedNumberOfConstantBirds));
    expect(randomBirdsFinder, findsNWidgets(expectedNumberOfRandomBirds));
  });
}

class TestWidget extends StatelessWidget {
  final Widget child;

  const TestWidget(this.child);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: child,
    );
  }
}
