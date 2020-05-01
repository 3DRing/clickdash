import 'package:clickdash/logic.dart';
import 'package:clickdash/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Store store;

  setUp(() {
    store = Store(AppState.initState);
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
        find.byKey(ValueKey('${MainPage}${BirdType.constant}'));

    expect(constantBirdFinder, findsOneWidget);
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
