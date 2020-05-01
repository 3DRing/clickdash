import 'dart:math';

import 'package:clickdash/logic.dart';
import 'package:flutter/material.dart';

const appName = 'ClickDash';

class Assets {
  static const dashBlueImage = 'assets/dash_blue.png';
  static const dashGreenImage = 'assets/dash_green.png';

  const Assets._();
}

final random = Random();
final calc = BirdCalc(random);
final store = Store(AppState.initState, calc);

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(
        store: store,
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final Store store;

  const MainPage({
    Key key,
    @required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            WalletView(store: store),
            Expanded(
              child: Center(
                child: StreamBuilder<AppState>(
                  initialData: store.state,
                  stream: store.changes,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    final state = snapshot.data;
                    var uniqueKey = 0;
                    return SingleChildScrollView(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        children: state.birds
                            .map((bird) => BirdView(
                                key: ValueKey(
                                    '$MainPage${bird.type}${uniqueKey++}'),
                                bird: bird))
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
            BirdStoreView(
              store: store,
              items: [
                Bird(BirdType.constant),
                Bird(BirdType.random),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BirdView extends StatelessWidget {
  static const size = 60.0;

  final Bird bird;
  final VoidCallback onTap;

  const BirdView({
    Key key,
    @required this.bird,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: InkResponse(
        child: Image.asset(_asset(bird.type)),
        onTap: onTap,
      ),
    );
  }

  String _asset(BirdType type) {
    switch (type) {
      case BirdType.constant:
        return Assets.dashBlueImage;
      case BirdType.random:
        return Assets.dashGreenImage;
    }
    return Assets.dashBlueImage;
  }
}

class BirdStoreView extends StatelessWidget {
  final Store store;
  final List<Bird> items;

  const BirdStoreView({
    Key key,
    @required this.store,
    @required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: items
              .map(
                (item) => BirdView(
                  key: ValueKey('$BirdStoreView${item.type}'),
                  bird: item,
                  onTap: () => store.buyBird(item.type),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class WalletView extends StatelessWidget {
  final Store store;

  const WalletView({
    Key key,
    @required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Баланс',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '\$${store.state.balance}',
                style: TextStyle(fontSize: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
