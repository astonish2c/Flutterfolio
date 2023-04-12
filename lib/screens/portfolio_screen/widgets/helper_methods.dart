import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../home_screen/widgets/utils.dart';
import '../../../provider/allCoins_provider.dart';
import '/provider/theme_provider.dart';
import '../../../provider/userCoins_provider.dart';
import '../../../model/coin_model.dart';

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

launchEmail() async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: 'astonish2c@gmail.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'I encountered a bug in Flutter Crypto wallet app.',
    }),
  );
  try {
    await launchUrl(params);
  } catch (e) {
    Utils.showSnackBar(e.toString());
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries.map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
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
    Utils.showSnackBar(e.toString());
  }
}
