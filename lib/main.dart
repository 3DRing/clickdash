import 'package:clickdash/logic.dart';
import 'package:flutter/material.dart';

const appName = 'ClickDash';

class Assets {
  static const dashBlueImage = 'assets/dash_blue.png';
  static const dashGreenImage = 'assets/dash_green.png';

  const Assets._();
}

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: BirdView(bird: Bird(BirdType.constant)),
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
