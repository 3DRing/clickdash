import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;
  final constantItemFinder = find.byValueKey('BirdStoreViewBirdType.constant');
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

  test('when balance less then 25 cannot tap constant bird', () async {
    await driver.tap(constantItemFinder);

    var actualBalance = await driver.getText(balanceFinder);
    expect(actualBalance, '\$3');

    for (var i = 0; i < 21; i++) {
      await driver.tap(firstBirdFinder);
    }

    await driver.tap(constantItemFinder);

    actualBalance = await driver.getText(balanceFinder);
    expect(actualBalance, '\$24');
  });

  test('when balance 25 then can buy constant bird and earn with it', () async {
    await driver.tap(firstBirdFinder);
    var actualBalance = await driver.getText(balanceFinder);
    expect(actualBalance, '\$25');

    await driver.tap(constantItemFinder);
    actualBalance = await driver.getText(balanceFinder);
    expect(actualBalance, '\$0');

    final secondBirdFinder = find.byValueKey('MainPageBirdType.constant1');

    await driver.waitFor(secondBirdFinder,
        timeout: Duration(milliseconds: 200));

    await driver.tap(secondBirdFinder);
    actualBalance = await driver.getText(balanceFinder);
    expect(actualBalance, '\$1');
  });
}
