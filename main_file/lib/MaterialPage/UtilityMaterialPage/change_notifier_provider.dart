import 'package:flutter/material.dart';

class CurrencyConverterChangeProvider
    extends ChangeNotifier {
  double
      _exchangeRate =
      0.0;
  var _updatedTime =
      "";

  String get updatedTime =>
      _updatedTime;

  double get exchangeRate =>
      _exchangeRate;

  void updateExchangeRate(
      double newRate) {
    _exchangeRate =
        newRate;
    notifyListeners();
  }

  void updateDateTime(
      String dateTime) {
    _updatedTime =
        dateTime;
    notifyListeners();
  }
}
