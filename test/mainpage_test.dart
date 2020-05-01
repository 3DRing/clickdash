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
