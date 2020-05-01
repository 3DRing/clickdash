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
          child: Text(appName),
        ),
      ),
    );
  }
}
