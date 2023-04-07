import 'package:crypto_exchange_app/provider/all_coins_provider.dart';
import 'package:crypto_exchange_app/provider/theme_provider.dart';
import 'package:crypto_exchange_app/provider/user_coins_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/coin_model.dart';

String calTotalAmount(CoinModel coin) {
  double totalAmountBuy = 0.0;

  double totalAmountSell = 0.0;

  for (var transaction in coin.transactions!) {
    if (transaction.isSell) {
      totalAmountSell += transaction.amount;
    } else {
      totalAmountBuy += transaction.amount;
    }
  }

  final double resultAmount = totalAmountBuy - totalAmountSell;

  if (double.tryParse(resultAmount.toString()) != null) {
    return resultAmount.toString();
  } else {
    return '0.00';
  }
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
  AllCoinsProvider allCoinsProvider = context.read<AllCoinsProvider>();
  UserCoinsProvider userCoinsProvider = context.read<UserCoinsProvider>();

  if (!userCoinsProvider.isFirstRunUser) return;

  try {
    await userCoinsProvider.setUserCoin();
    await allCoinsProvider.setDatabaseCoins();
  } catch (e) {
    print(e);
  }
}
