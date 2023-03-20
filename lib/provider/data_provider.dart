// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/coin_model.dart';

class DataProvider with ChangeNotifier {
  double totalUserBalance = 0.0;
  double marketCapPercentage = 0;
  bool firstRun = true;

  final Map<String, CoinModel> _allCoins = {};

  final Map<String, CoinModel> _userCoins = {};

  List<CoinModel> get allCoins {
    return [..._allCoins.values];
  }

  List<CoinModel> get userCoins {
    return [..._userCoins.values];
  }

  Future<void> periodicSetAllCoin() async {
    Timer.periodic(const Duration(seconds: 15), (timer) async {
      await setAllCoins();
    });
  }

  Future<void> setAllCoins() async {
    Future<void> setTotalMC() async {
      firstRun = false;
      var response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/global'));
      if (response.statusCode != 200) return print('setTotalMC failed: ${response.body}');
      var list = Map<String, dynamic>.from(json.decode(response.body));
      var data = list['data'] as Map<String, dynamic>;
      marketCapPercentage = data['market_cap_change_percentage_24h_usd'];
    }

    await setTotalMC();
    http.Response response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=1'));
    if (response.statusCode != 200) return print('setAllCoins failed: ${response.body}');
    List<dynamic> coinsDynamic = json.decode(response.body);
    setAndUpdateAllCoin(coinsDynamic);
    notifyListeners();
  }

  Future<void> fetchAllCoinsFirebase() async {
    DatabaseReference dr = FirebaseDatabase.instance.ref();
    DataSnapshot ds = await dr.child('allCoins/').orderByChild('current_price').get();
    if (!ds.exists) return print('Fetching allCoins from firestore failed.');
    addAllCoin(ds);
  }

  Future<void> setAndUpdateAllCoin(List<dynamic> coins) async {
    DatabaseReference dr = FirebaseDatabase.instance.ref('allCoins/');
    Map<String, dynamic> listJsonData = returnJsonData(coins);

    await dr.update(listJsonData).then((value) {
      print('coins updated in firebase.');
      if (_allCoins.length < coins.length) {
        for (var coin in coins) {
          CoinModel cm = CoinModel.fromJson(coin);
          _allCoins.putIfAbsent(cm.symbol, () => cm);
        }
      } else {
        for (var coin in coins) {
          CoinModel cm = CoinModel.fromJson(coin);
          _allCoins.update(cm.symbol, (value) => cm);
        }
      }
    });
  }

  void addAllCoin(DataSnapshot ds) {
    final Map<String, dynamic> coinsMapDynamic = Map<String, dynamic>.from(ds.value as Map<Object?, Object?>);

    final List<String> coinsKey = coinsMapDynamic.keys.toList();

    for (int i = 0; i < coinsKey.length; i++) {
      final Map<String, dynamic> coinMap = Map<String, dynamic>.from(coinsMapDynamic.values.toList()[i] as Map<Object?, Object?>);

      CoinModel coin = CoinModel.fromJson(coinMap);

      _allCoins.putIfAbsent(
        coin.symbol,
        () => CoinModel(
          currentPrice: coin.currentPrice,
          name: coin.name,
          symbol: coin.symbol,
          image: coin.image,
          priceDiff: coin.priceDiff,
          color: Colors.blue,
        ),
      );
    }
    notifyListeners();
  }

  Map<String, dynamic> returnJsonData(List<dynamic> coinsList) {
    Map<String, dynamic> listJsonData = {};

    for (var coinItem in coinsList) {
      CoinModel coin = CoinModel.fromJson(coinItem as Map<String, dynamic>);
      final jsonCoin = coin.toJson();
      listJsonData.putIfAbsent(coin.symbol, () => jsonCoin);
    }
    return listJsonData;
  }

  StreamSubscription setUserCoin() {
    DatabaseReference userCoinsRef = FirebaseDatabase.instance.ref('userCoins/');

    StreamSubscription streamSubscription = userCoinsRef.onValue.listen((event) {
      if (event.snapshot.value == null) return print('userCoins is empty in firebase.');

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

        _userCoins.putIfAbsent(
          coin.symbol,
          () => CoinModel(
            currentPrice: coin.currentPrice,
            name: coin.name,
            symbol: coin.symbol,
            image: coin.image,
            priceDiff: coin.priceDiff,
            color: Colors.blue,
            transactions: transactions,
          ),
        );
        calTotalUserBalance();
      }
    });
    return streamSubscription;
  }

  void addUserCoin(CoinModel coinModel) {
    final String coinUrl = 'userCoins/${coinModel.symbol}';
    final String symbol = coinModel.symbol;

    if (_userCoins.containsKey(coinModel.symbol)) {
      addTransaction(coinModel.transactions![0], coinUrl, symbol);
    } else {
      addCoin(coinModel);
    }
  }

  Future<void> addCoin(CoinModel coin) async {
    DatabaseReference coinRef = FirebaseDatabase.instance.ref('userCoins/${coin.symbol}');

    final String transactionId = coinRef.push().key as String;

    final Transaction transaction = coin.transactions![0].addId(coin.transactions![0], transactionId);

    await coinRef.set({
      'current_price': coin.currentPrice,
      'name': coin.name,
      'symbol': coin.symbol,
      'image': coin.image,
      'price_change_percentage_24h': coin.priceDiff,
      'color': coin.color.toString(),
      'transactions': transaction.toJson(),
    });

    _userCoins.putIfAbsent(
      coin.symbol,
      () => CoinModel(
        currentPrice: coin.currentPrice,
        name: coin.name,
        symbol: coin.symbol,
        image: coin.image,
        priceDiff: coin.priceDiff,
        color: coin.color,
        transactions: [transaction],
      ),
    );
    calTotalUserBalance();
  }

  Future<void> addTransaction(Transaction getTransaction, String coinUrl, String symbol) async {
    DatabaseReference transactionsRef = FirebaseDatabase.instance.ref('$coinUrl/transactions');

    final String transactionId = transactionsRef.push().key as String;

    final Transaction transaction = getTransaction.addId(getTransaction, transactionId);

    await transactionsRef.update(transaction.toJson());

    _userCoins.update(symbol, (coin) {
      coin.transactions!.add(transaction);

      return CoinModel(
        currentPrice: coin.currentPrice,
        name: coin.name,
        symbol: coin.symbol,
        image: coin.image,
        priceDiff: coin.priceDiff,
        color: coin.color,
        transactions: coin.transactions,
      );
    });
    calTotalUserBalance();
  }

  Future<void> updateTransaction(CoinModel coin, int transactionIndex, Transaction transaction) async {
    final String transactionId = coin.transactions![transactionIndex].id as String;

    DatabaseReference transactionRef = FirebaseDatabase.instance.ref('userCoins/${coin.symbol}/transactions/');

    Transaction assignedId = transaction.addId(transaction, transactionId);

    await transactionRef.update(assignedId.toJson());

    coin.transactions!.removeAt(transactionIndex);
    coin.transactions!.insert(transactionIndex, assignedId);

    calTotalUserBalance();
  }

  Future<bool> removeTransaction({required CoinModel coin, required int transactionIndex}) async {
    final List<Transaction> transactions = coin.transactions as List<Transaction>;

    final String transactionId = transactions[transactionIndex].id as String;

    final DatabaseReference coinRef = FirebaseDatabase.instance.ref('userCoins/${coin.symbol}');
    final DatabaseReference transactionRef = FirebaseDatabase.instance.ref('userCoins/${coin.symbol}/transactions/$transactionId');

    if (coin.transactions!.length == 1) {
      await coinRef.remove();
      removeItem(coin);
      calTotalUserBalance();
      return true;
    } else {
      await transactionRef.remove();
      _userCoins[coin.symbol.toLowerCase()]!.transactions!.removeAt(transactionIndex);
      calTotalUserBalance();
      return false;
    }
  }

  void removeItem(CoinModel coinModel) {
    _userCoins.remove(coinModel.symbol);
  }

  void calTotalUserBalance() {
    double total = 0.0;
    for (var coin in userCoins) {
      for (var transaction in coin.transactions!) {
        if (transaction.isSell) {
          total -= transaction.amount * transaction.buyPrice;
        } else {
          total += transaction.amount * transaction.buyPrice;
        }
      }
    }
    totalUserBalance = total;
    notifyListeners();
  }
}
