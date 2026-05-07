extension NumMoneyFormat on num {
  String toMoney([String currency = 'USD']) =>
      '$currency ${toStringAsFixed(2)}';
}
