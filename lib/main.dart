import 'dart:math';

import 'package:clickdash/logic.dart';
import 'package:flutter/material.dart';

const appName = 'ClickDash';

class Assets {
  static const dashBlueImage = 'assets/dash_blue.png';
  static const dashGreenImage = 'assets/dash_green.png';
  static const dashOrangeImage = 'assets/dash_orange.png';

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
                            .map(
                              (bird) => BirdView(
                                key: ValueKey(
                                    '$MainPage${bird.type}${uniqueKey++}'),
                                type: bird.type,
                                onTap: () => store.earn(bird),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
            BirdStoreView(store: store),
          ],
        ),
      ),
    );
  }
}

class BirdView extends StatelessWidget {
  static const size = 60.0;

  final BirdType type;
  final VoidCallback onTap;

  const BirdView({
    Key key,
    @required this.type,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: InkResponse(
        child: Image.asset(_asset(type)),
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
      case BirdType.combo:
        return Assets.dashOrangeImage;
    }
    return Assets.dashBlueImage;
  }
}

class BirdStoreView extends StatelessWidget {
  final Store store;

  const BirdStoreView({
    Key key,
    @required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<AppState>(
            initialData: store.state,
            stream: store.changes,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              final state = snapshot.data;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: state.items
                    .map(
                      (item) => Opacity(
                        opacity: item.price <= state.balance ? 1.0 : 0.2,
                        child: BirdView(
                          key: ValueKey('$BirdStoreView${item.type}'),
                          type: item.type,
                          onTap: item.price <= state.balance
                              ? () => store.buyBird(item)
                              : null,
                        ),
                      ),
                    )
                    .toList(),
              );
            }),
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
              StreamBuilder<AppState>(
                initialData: store.state,
                stream: store.changes,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  final state = snapshot.data;
                  return Text(
                    '\$${state.balance}',
                    key: ValueKey('${WalletView}balance'),
                    style: TextStyle(fontSize: 28),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
