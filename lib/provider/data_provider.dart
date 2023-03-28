// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:async';

import 'package:firebase_database/firebase_database.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/coin_model.dart';

class DataProvider with ChangeNotifier {
  int timerValue = 5;

  double totalUserBalance = 0.0;
  double pMarketChange = 0.0;

  bool firstRun = true;
  bool is_DataBase_Available = false;
  bool isLoading = false;
  bool hasError = false;

  final Map<String, CoinModel> _coins = {};

  final Map<String, CoinModel> _userCoins = {};

  List<CoinModel> get getCoins {
    return [..._coins.values];
  }

  List<CoinModel> get userCoins {
    return [..._userCoins.values];
  }

  DatabaseReference dr = FirebaseDatabase.instance.ref();

  Future<void> setDbCoins() async {
    Future<void> getPercentage() async {
      try {
        final mChangePercentage = await dr.child('mChangePercentage').get();

        if (!mChangePercentage.exists) {
          throw ('getting mChangePercentage failed.');
        }

        pMarketChange = mChangePercentage.value as double;

        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }

    try {
      isLoading = true;

      print('setDBCoins called');

      await getPercentage();

      DataSnapshot ds = await dr.child('coins/').get();

      if (!ds.exists) {
        throw ('Fetching coins from firebase failed.');
      }

      final Map<String, dynamic> coinsMapDynamic = Map<String, dynamic>.from(ds.value as Map<Object?, Object?>);

      final List<String> coinsKey = coinsMapDynamic.keys.toList();

      if (_coins.values.length < coinsKey.length) {
        for (int i = 0; i < coinsKey.length; i++) {
          final Map<String, dynamic> coinMap = Map<String, dynamic>.from(coinsMapDynamic.values.toList()[i] as Map<Object?, Object?>);

          CoinModel coin = CoinModel.fromJson(coinMap);

          _coins.putIfAbsent(
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
      } else {
        for (int i = 0; i < coinsKey.length; i++) {
          final Map<String, dynamic> coinMap = Map<String, dynamic>.from(coinsMapDynamic.values.toList()[i] as Map<Object?, Object?>);

          CoinModel coin = CoinModel.fromJson(coinMap);

          _coins.update(
            coin.symbol,
            (_) => CoinModel(
              currentPrice: coin.currentPrice,
              name: coin.name,
              symbol: coin.symbol,
              image: coin.image,
              priceDiff: coin.priceDiff,
              color: Colors.blue,
            ),
          );
        }
      }

      print("Fetching done from DB.");

      isLoading = false;
      is_DataBase_Available = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setApiCoins(List<dynamic> coinsDynamic, double mChangePercentage) async {
    try {
      Map<String, dynamic> coinsJson = returnJsonData(coinsDynamic);

      await dr.update({'mChangePercentage': mChangePercentage});

      await dr.child('coins/').update(coinsJson);

      if (_coins.isEmpty) {
        for (var coin in coinsDynamic) {
          CoinModel cm = CoinModel.fromJson(coin);
          _coins.putIfAbsent(cm.symbol, () => cm);
        }
      } else {
        for (var coin in coinsDynamic) {
          CoinModel cm = CoinModel.fromJson(coin);
          _coins.update(
            cm.symbol,
            (value) => cm,
            ifAbsent: () {
              return _coins.putIfAbsent(cm.symbol, () => cm);
            },
          );
        }
      }
      is_DataBase_Available = true;
      notifyListeners();
    } catch (e) {
      print('$e');
    }
  }

  Future<void> getApiCoins() async {
    Future<double> setMcPercentage() async {
      try {
        print('mChangePercentage called');

        http.Response rMarketChange = await http.get(Uri.parse('https://api.coingecko.com/api/v3/global'));

        if (rMarketChange.statusCode != 200) {
          isLoading = false;
          hasError = true;
          notifyListeners();

          throw ('Failed to fetch market data.');
        }

        Map<String, dynamic> vMarketChange = Map<String, dynamic>.from(json.decode(rMarketChange.body));

        final double marketCapPercentage = (vMarketChange['data'] as Map<String, dynamic>)['market_cap_change_percentage_24h_usd'];

        pMarketChange = marketCapPercentage;

        return pMarketChange;
      } catch (e) {
        rethrow;
      }
    }

    try {
      isLoading = true;
      notifyListeners();

      final double mChangePercentage = await setMcPercentage();

      print('Calling API');

      http.Response rCoins = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=1'));

      if (rCoins.statusCode != 200) {
        isLoading = false;
        hasError = true;
        notifyListeners();

        throw ('getApiCoins: ${rCoins.statusCode}');
      }

      print('API call done');

      List<dynamic> coinsDynamic = json.decode(rCoins.body);

      await setApiCoins(coinsDynamic, mChangePercentage);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> periodicSetCoins() async {
    print('periodicSetCoins called');

    Timer.periodic(Duration(seconds: timerValue), (timer) async {
      try {
        await getApiCoins();

        timer.cancel();
      } catch (e) {
        timer.cancel();

        Timer.periodic(const Duration(seconds: 1), (timer) async {
          timerValue -= 1;
          notifyListeners();

          if (timerValue != 0) return;
          timer.cancel();

          timerValue = 5;
          notifyListeners();

          await getApiCoins();
        });
      }
    });
  }

  Map<String, dynamic> returnJsonData(List<dynamic> coinsList) {
    Map<String, dynamic> listJsonData = {};

    for (var coinItem in coinsList) {
      CoinModel coin = CoinModel.fromJson(coinItem as Map<String, dynamic>);
      final jsonCoin = coin.toJson();
      listJsonData.putIfAbsent(("0${coin.market_cap_rank}"), () => jsonCoin);
    }
    return listJsonData;
  }

  Future<void> setUserCoins() async {
    final DataSnapshot ds = await dr.child('userCoins/').get();

    if (!ds.exists) throw ('Fetching userCoins from firebase failed.');

    final Map<String, dynamic> dUserCoins = Map<String, dynamic>.from(ds.value as Map<Object?, Object?>);

    final List<String> coinsKey = dUserCoins.keys.toList();

    for (int i = 0; i < coinsKey.length; i++) {
      final Map<String, dynamic> coinMap = Map<String, dynamic>.from(dUserCoins.values.toList()[i] as Map<Object?, Object?>);

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
        ),
      );
    }
    notifyListeners();
    print('');
  }

  StreamSubscription setUserCoin() {
    firstRun = false;

    StreamSubscription streamSubscription = dr.child('userCoins/').onValue.listen((event) {
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
      }
      calTotalUserBalance();
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

    try {
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
    } catch (e) {
      print(e);
    }
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
