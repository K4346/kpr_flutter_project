import 'package:flutter/material.dart';

import 'currency_entity.dart';

class Utils {

  // отрезает цифры у числа с плавающей точкой
  // по умолчанию 3 цифры после запятой
  formatDoubleToDisplayingAmount(double number, int? decimalPoint_) {
    int decimalPoint;
    if (decimalPoint_ == null) {
      decimalPoint = 3;
    } else {
      decimalPoint = decimalPoint_;
    }
    String str = number.toString();
    int zeroCount = -1;
    for (int i = 0; i < str.length; i++) {
      if (str[i] == '.') {
        zeroCount = 0;
        if (zeroCount == decimalPoint) {
          return str.substring(0, i);
        }
        continue;
      }
      if (zeroCount != -1) {
        zeroCount += 1;
        if (zeroCount == decimalPoint) {
          return str.substring(0, i + 1);
        }
      }
    }
    return str;
  }


  getCurrenciesByDynamics( Map<String,CurrencyEntity> currencies) {
    List<String> pros = [];
    List<String> cons = [];
    List<String> equal = [];
    currencies.forEach((k,currency) => {
    {
        if (currency.previous < currency.value) {
          pros.add(currency.charCode)
        } else if (currency.previous > currency.value) {
          cons.add(currency.charCode)
        } else {
          equal.add(currency.charCode)
        }
      }
    });
    return [pros, cons, equal];
  }

  List<DropdownMenuItem<String>> getCurrenciesForDropDown(Map<String,CurrencyEntity> currencies) {
    List<DropdownMenuItem<String>> menuItems = [];
    currencies.forEach((k,currency) =>{
      {
        menuItems.add(DropdownMenuItem(value: currency.charCode, child: Text(currency.charCode)))
      }
    });
    return menuItems;
  }

  String showNominalCurrency(int? nominal, CurrencyEntity? currency) {
    if (currency == null || nominal == null || currency.value <= 0 ||
        currency.nominal < 1 || nominal < 1) return "";
    double amount = currency.value * nominal / currency.nominal;
    return '${nominal.toString()} ${currency
        .charCode} = ${formatDoubleToDisplayingAmount(amount, null)}₽';
  }

  String getCurrencyNamesFromList(List<String> list) {
    String text = "";
    for (int i = 0; i < list.length; i++) {
      text += list[i];
      if (i != list.length - 1) {
        text += ", ";
      } else
        text += ".";
    }
    return text;
  }
}