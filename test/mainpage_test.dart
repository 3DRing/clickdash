import 'dart:math';

import 'package:clickdash/logic.dart';
import 'package:clickdash/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'birdcalc_test.dart';

void main() {
  Random random;
  BirdCalc calc;
  Store store;

  setUp(() {
    random = MockRandom();
    calc = BirdCalc(random);
    store = Store(AppState.initState, calc);
  });

  testWidgets('when initialized then items are seen', (tester) async {
    await tester.pumpWidget(TestWidget(MainPage(store: store)));

    final constantItemFinder =
        find.byKey(ValueKey('$BirdStoreView${BirdType.constant}'));
    final randomItemFinder =
        find.byKey(ValueKey('$BirdStoreView${BirdType.random}'));

    await tester.pump();

    expect(constantItemFinder, findsOneWidget);
    expect(randomItemFinder, findsOneWidget);
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
