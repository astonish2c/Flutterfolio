import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/coin_model.dart';
import '../../provider/data_provider.dart';

String calTotalAmount(CoinModel coin) {
  double totalAmount = 0.0;

  for (var transaction in coin.transactions!) {
    if (transaction.isSell) {
      totalAmount -= transaction.amount;
    } else {
      totalAmount += transaction.amount;
    }
  }
  return totalAmount.toString();
}

String calTotalCost(CoinModel coin) {
  double totalCost = 0.0;

  for (var transaction in coin.transactions!) {
    if (transaction.isSell) {
      totalCost -= transaction.buyPrice * transaction.amount;
    } else {
      totalCost += transaction.buyPrice * transaction.amount;
    }
  }
  return totalCost.toString();
}

Future<void> setValues({required BuildContext context}) async {
  DataProvider dataProvider = context.read<DataProvider>();

  if (!dataProvider.isFirstRunUser) return;

  try {
    await dataProvider.setUserCoin();
    await dataProvider.setDatabaseCoins();
  } catch (e) {
    print(e);
  }
}
