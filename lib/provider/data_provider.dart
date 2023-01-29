// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_database/firebase_database.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/coin_model.dart';

class DataProvider with ChangeNotifier {
  double totalUserBalance = 0.0;
  double marketCapPercentage = 0;
  bool firstRun = true;
  bool isRunning = false;

  final Map<String, CoinModel> _allCoins = {};

  final Map<String, CoinModel> _userCoins = {};

  List<CoinModel> get allCoins {
    return [..._allCoins.values];
  }

  List<CoinModel> get userCoins {
    return [..._userCoins.values];
  }

  void periodicSetAllCoin() {
    Timer.periodic(const Duration(seconds: 15), (timer) {
      setAllCoins();
    });
  }

  void totalMC() async {
    print('Is first run? $firstRun');
    firstRun = false;
    var response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/global'));
    if (response.statusCode == 200) {
      var list = Map<String, dynamic>.from(json.decode(response.body));
      var data = list['data'] as Map<String, dynamic>;
      marketCapPercentage = data['market_cap_change_percentage_24h_usd'];
    } else {
      throw Exception('Could not retrieve, Total Market Cap Change.');
    }
  }

  Future<void> setAllCoins() async {
    print('Attempting');
    totalMC();
    http.Response response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=1'));

    if (response.statusCode == 200) {
      List<dynamic> coins = json.decode(response.body);

      if (_allCoins.isEmpty) {
        for (var coin in coins) {
          CoinModel cm = CoinModel.fromJson(coin as Map<String, dynamic>);
          _allCoins.putIfAbsent(cm.shortName, () => cm);
        }
      } else {
        for (var coin in coins) {
          CoinModel cm = CoinModel.fromJson(coin as Map<String, dynamic>);
          _allCoins.update(cm.shortName, (value) => cm);
        }
      }
      notifyListeners();
    } else {
      throw Exception('Could not get data from API, try again.');
    }
  }

  void setUserCoin() {
    DatabaseReference userCoinsRef = FirebaseDatabase.instance.ref('userCoins/');

    userCoinsRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final Map<String, dynamic> coinsUndefined = Map<String, dynamic>.from(event.snapshot.value as Map<Object?, Object?>);

        final List<Map<String, dynamic>> coinsValue = coinsUndefined.values.toList().map((e) => Map<String, dynamic>.from(e as Map<Object?, Object?>)).toList();

        for (var coin in coinsValue) {
          final Map<String, dynamic> coinTransactions = Map<String, dynamic>.from(coin['transactions'] as Map<Object?, Object?>);

          final List<Map<String, dynamic>> transactionsValue = coinTransactions.values.toList().map((e) => Map<String, dynamic>.from(e as Map<Object?, Object?>)).toList();

          List<Transaction> transactions = [];

          for (var transaction in transactionsValue) {
            transactions.add(
              Transaction(
                buyPrice: double.parse(transaction['buyPrice'].toString()),
                amount: double.parse(transaction['amount'].toString()),
                dateTime: DateTime.parse(transaction['dateTime']),
                id: transaction['id'],
              ),
            );
          }

          _userCoins.putIfAbsent(
            coin['shortName'],
            () => CoinModel(
              currentPrice: double.parse(coin['currentPrice'].toString()),
              name: coin['name'],
              shortName: coin['shortName'],
              imageUrl: coin['imageUrl'],
              priceDiff: coin['priceDiff'],
              color: Colors.blue,
              transactions: transactions,
            ),
          );
        }
        calTotalUserBalance();
      } else {
        print('DataBase is empty');
      }
    });
  }

  void addUserCoin(CoinModel coinModel) {
    final String coinUrl = 'userCoins/${coinModel.shortName}';
    final String coinId = coinModel.shortName;

    if (_userCoins.containsKey(coinModel.shortName)) {
      addTransaction(coinModel.transactions![0], coinUrl, coinId);
    } else {
      addCoin(coinModel);
    }
  }

  Future<void> addCoin(CoinModel coin) async {
    DatabaseReference coinRef = FirebaseDatabase.instance.ref('userCoins/${coin.shortName}');

    final String transactionId = coinRef.push().key as String;

    final Map<String, dynamic> transactionMap = transactionToMap(coin.transactions![0], transactionId);

    await coinRef.set({
      'currentPrice': coin.currentPrice,
      'name': coin.name,
      'shortName': coin.shortName,
      'imageUrl': coin.imageUrl,
      'priceDiff': coin.priceDiff,
      'color': coin.color.toString(),
      'transactions': transactionMap,
    });

    coin.transactions![0] = addTransactionId(coin.transactions![0], transactionId);

    _userCoins.putIfAbsent(
      coin.shortName,
      () => CoinModel(
        currentPrice: coin.currentPrice,
        name: coin.name,
        shortName: coin.shortName,
        imageUrl: coin.imageUrl,
        priceDiff: coin.priceDiff,
        color: coin.color,
        transactions: coin.transactions,
      ),
    );
    calTotalUserBalance();
  }

  Future<void> addTransaction(Transaction transaction, String coinUrl, String coinId) async {
    DatabaseReference transactionsRef = FirebaseDatabase.instance.ref('$coinUrl/transactions');

    final String transactionId = transactionsRef.push().key as String;

    final Map<String, dynamic> transactionMap = transactionToMap(transaction, transactionId);

    await transactionsRef.update(transactionMap);

    _userCoins.update(coinId, (coin) {
      final Transaction updatedTransaction = addTransactionId(transaction, transactionId);

      coin.transactions!.add(updatedTransaction);

      return CoinModel(
        currentPrice: coin.currentPrice,
        name: coin.name,
        shortName: coin.shortName,
        imageUrl: coin.imageUrl,
        priceDiff: coin.priceDiff,
        color: coin.color,
        transactions: coin.transactions,
      );
    });
    calTotalUserBalance();
  }

  Future<void> updateTransaction(CoinModel coin, int transactionIndex, Transaction transaction) async {
    final String transactionId = coin.transactions![transactionIndex].id as String;

    DatabaseReference transactionRef = FirebaseDatabase.instance.ref('userCoins/${coin.shortName}/transactions/$transactionId/');

    final Transaction updatedTransaction = addTransactionId(transaction, transactionId);

    transactionRef.update({
      'buyPrice': transaction.buyPrice,
      'amount': transaction.amount,
      'dateTime': transaction.dateTime.toIso8601String(),
    });

    final List<Transaction> lBuyCoin = coin.transactions!;
    lBuyCoin.removeAt(transactionIndex);
    lBuyCoin.insert(transactionIndex, updatedTransaction);

    calTotalUserBalance();
  }

  Future<bool> removeTransaction({required CoinModel coin, required int transactionIndex}) async {
    final List<Transaction> transactions = coin.transactions as List<Transaction>;

    final String transactionId = transactions[transactionIndex].id as String;

    final DatabaseReference coinRef = FirebaseDatabase.instance.ref('userCoins/${coin.shortName}');
    final DatabaseReference transactionRef = FirebaseDatabase.instance.ref('userCoins/${coin.shortName}/transactions/$transactionId');

    if (coin.transactions!.length == 1) {
      await coinRef.remove();
      removeItem(coin);
      calTotalUserBalance();
      return true;
    } else {
      await transactionRef.remove();
      _userCoins[coin.shortName.toLowerCase()]!.transactions!.removeAt(transactionIndex);
      calTotalUserBalance();
      return false;
    }
  }

  Transaction addTransactionId(Transaction transaction, String transactionId) {
    return Transaction(buyPrice: transaction.buyPrice, amount: transaction.amount, dateTime: transaction.dateTime, id: transactionId);
  }

  void removeItem(CoinModel coinModel) {
    //implement NotifyListeners()
    _userCoins.remove(coinModel.shortName);
  }

  Map<String, dynamic> transactionToMap(Transaction transaction, String transactionId) {
    Map<String, dynamic> transactionMap = {
      transactionId: {
        'buyPrice': transaction.buyPrice,
        'amount': transaction.amount,
        'dateTime': transaction.dateTime.toIso8601String(),
        'id': transactionId,
      }
    };

    return transactionMap;
  }

  double calTotalValue(CoinModel coinModel) {
    double totalValue = 0.0;

    for (var buyCoin in coinModel.transactions!) {
      totalValue += buyCoin.amount * buyCoin.buyPrice;
    }

    return totalValue;
  }

  String calTotalAmount(CoinModel coinModel) {
    double totalAmount = 0.0;

    for (var buyCoin in coinModel.transactions!) {
      totalAmount += buyCoin.amount;
    }

    return totalAmount.toString();
  }

  void calTotalUserBalance() {
    double total = 0.0;
    for (var coin in userCoins) {
      for (var transaction in coin.transactions!) {
        total += transaction.amount * transaction.buyPrice;
      }
    }
    totalUserBalance = total;
    notifyListeners();
  }
}
