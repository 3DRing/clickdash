import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  final firstBirdFinder = find.byValueKey('MainPageBirdType.constant0');
  final balanceFinder = find.byValueKey('WalletViewbalance');

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });

  test('when init then 0 balance', () async {
    final actualBalance = await driver.getText(balanceFinder);
    expect(actualBalance, '\$0');
  });

  test('when clicking constant bird then balance increments', () async {
    await driver.tap(firstBirdFinder);
    await driver.tap(firstBirdFinder);
    await driver.tap(firstBirdFinder);

    final actualBalance = await driver.getText(balanceFinder);
    expect(actualBalance, '\$3');
  });
}
