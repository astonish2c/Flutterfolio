import 'dart:convert';

import 'package:firebase_database/firebase_database.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/coin_model.dart';

Map<String, dynamic> returnJsonData({required List<dynamic> coinsList}) {
  Map<String, dynamic> listJsonData = {};

  for (var coinItem in coinsList) {
    CoinModel coin = CoinModel.fromJson(coinItem as Map<String, dynamic>);
    final jsonCoin = coin.toJson();
    listJsonData.putIfAbsent(("0${coin.market_cap_rank}"), () => jsonCoin);
  }
  return listJsonData;
}

double addMarketStatus(http.Response rMarketStatus) {
  Map<String, dynamic> vMarketChange = Map<String, dynamic>.from(json.decode(rMarketStatus.body));
  final double marketCapPercentage = (vMarketChange['data'] as Map<String, dynamic>)['market_cap_change_percentage_24h_usd'];
  return marketCapPercentage;
}

void addFetchedUserCoins({required DatabaseEvent event, required Map<String, CoinModel> userCoins}) {
  if (event.snapshot.value == null) return;

  final Map<String, dynamic> coinsMapDynamic = Map<String, dynamic>.from(event.snapshot.value as Map<Object?, Object?>);
  final List<String> coinsKey = coinsMapDynamic.keys.toList();

  for (int i = 0; i < coinsKey.length; i++) {
    final Map<String, dynamic> coinMap = Map<String, dynamic>.from(coinsMapDynamic.values.toList()[i] as Map<Object?, Object?>);
    Map<String, dynamic> transactionsMap = Map<String, dynamic>.from(coinMap['transactions'] as Map<Object?, Object?>);
    final List<Transaction> transactions = [];

    for (var transactionItem in transactionsMap.values) {
      final Transaction transaction = Transaction.fromJson(Map<String, dynamic>.from(transactionItem as Map<Object?, Object?>));
      transactions.add(transaction);
    }

    CoinModel coin = CoinModel.fromJson(coinMap);
    userCoins.putIfAbsent(
      coin.symbol,
      () => CoinModel(
        currentPrice: coin.currentPrice,
        name: coin.name,
        symbol: coin.symbol,
        image: coin.image,
        priceDiff: coin.priceDiff,
        market_cap_rank: coin.market_cap_rank,
        transactions: transactions,
      ),
    );
  }
}

void addDatabaseCoins({required DataSnapshot dsCoins, required Map<String, CoinModel> coins}) {
  final Map<String, dynamic> coinsMapDynamic = Map<String, dynamic>.from(dsCoins.value as Map<Object?, Object?>);
  final List<String> coinsKey = coinsMapDynamic.keys.toList();

  if (coins.values.length < coinsKey.length) {
    for (int i = 0; i < coinsKey.length; i++) {
      final Map<String, dynamic> coinMap = Map<String, dynamic>.from(coinsMapDynamic.values.toList()[i] as Map<Object?, Object?>);
      CoinModel coin = CoinModel.fromJson(coinMap);
      coins.putIfAbsent(
        coin.symbol,
        () => CoinModel(
          currentPrice: coin.currentPrice,
          name: coin.name,
          symbol: coin.symbol,
          image: coin.image,
          priceDiff: coin.priceDiff,
          market_cap_rank: coin.market_cap_rank,
        ),
      );
    }
  } else {
    for (int i = 0; i < coinsKey.length; i++) {
      final Map<String, dynamic> coinMap = Map<String, dynamic>.from(coinsMapDynamic.values.toList()[i] as Map<Object?, Object?>);
      CoinModel coin = CoinModel.fromJson(coinMap);
      coins.update(
        coin.symbol,
        (_) => CoinModel(
          currentPrice: coin.currentPrice,
          name: coin.name,
          symbol: coin.symbol,
          image: coin.image,
          priceDiff: coin.priceDiff,
          market_cap_rank: coin.market_cap_rank,
        ),
      );
    }
  }
}
