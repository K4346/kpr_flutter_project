// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:kpr_flutter_project/currency_entity.dart';
import 'package:kpr_flutter_project/utils.dart';

void main() {

  Utils utils = Utils();

// formatFloatToDisplayingAmount

  test('знаков больше чем нужно', () =>
  {
    expect(utils.formatDoubleToDisplayingAmount(3.3122342, null), "3.312")
  });

  test('1 цифра вместо 3', () =>
  {
    expect(utils.formatDoubleToDisplayingAmount(3.1, 3), "3.1")
  });

  test('скос всех цифр', () =>
  {
    expect(utils.formatDoubleToDisplayingAmount(3.32, 0), "3")
  });

  test('нужно столько же цифр сколько есть', () =>
  {
    expect(utils.formatDoubleToDisplayingAmount(3.32, 2), "3.32")
  });


// showNominalCurrency

  CurrencyEntity currencyEntity = const CurrencyEntity(
      charCode: "USD",
      nominal: 5,
      value: 100,
      name: 'sdas',
      previous: 444444
  );

  test('обычный рабочий сценарий с всеми данными', () => {
  expect(utils.showNominalCurrency(1, currencyEntity), "1 USD = 20.0₽")
  });

  test('номинал=0', () => {
    expect(utils.showNominalCurrency(0, currencyEntity), "")
  });

  test('номинал отрицательный', () => {
    expect(utils.showNominalCurrency(-5, currencyEntity), "")
  });

}
