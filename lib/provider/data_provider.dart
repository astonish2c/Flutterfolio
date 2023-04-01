import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '/provider/utils/helper_methods.dart';
import '../model/coin_model.dart';

class DataProvider with ChangeNotifier {
  int timerValue = 5;

  double userBalance = 0.0;
  double marketStatus = 0.0;

  bool firstRun = true;
  bool isDatabaseAvailable = false;

  bool isLoadingDatabase = false;
  bool hasErrorDatabase = false;

  bool isLoadingMarket = true;
  bool hasErrorMarket = false;
  bool isRetry = false;

  bool isLoadingUserCoin = false;
  bool hasErrorUserCoin = false;
  bool isFirstRunUser = true;

  final Map<String, CoinModel> _coins = {};

  final Map<String, CoinModel> _userCoins = {};

  List<CoinModel> get getCoins {
    return [..._coins.values];
  }

  List<CoinModel> get userCoins {
    return [..._userCoins.values];
  }

  void setFirstRun() {
    firstRun = false;
    notifyListeners();
  }

  DatabaseReference dr = FirebaseDatabase.instance.ref();

  final Uri uriMarketStatus = Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=1');

  final Uri uriApiMarketStatus = Uri.parse('https://api.coingecko.com/api/v3/global');

  Future<void> setUserCoin() async {
    await checkConnectivity(loadingField: isLoadingUserCoin, errorField: hasErrorUserCoin, notifyListeners: callNotifyListeners);

    if (hasErrorUserCoin) hasErrorUserCoin = false;
    isLoadingUserCoin = true;
    notifyListeners();

    dr.child('userCoins/').onValue.listen((event) {
      if (event.snapshot.value == null) setNullFailedFields();

      addMapUserCoin(event: event, userCoins: _userCoins);

      isFirstRunUser = false;
      isLoadingUserCoin = false;

      calTotalUserBalance();
    });
  }

  Future<void> setDatabaseCoins() async {
    try {
      await checkConnectivity(errorField: hasErrorDatabase, loadingField: isLoadingDatabase, notifyListeners: callNotifyListeners);

      if (hasErrorDatabase) hasErrorDatabase = false;
      isLoadingDatabase = true;
      notifyListeners();

      await getMarketStatus();

      DataSnapshot dataSnapshot = await dr.child('coins/').get();

      if (!dataSnapshot.exists) {
        isDatabaseAvailable = false;
        notifyListeners();
        throw ('Fetching coins from firebase failed.');
      }

      addDbCoins(dataSnapshot: dataSnapshot, coins: _coins);

      setDbSuccessFields();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getApiCoins() async {
    try {
      await Future.delayed(Duration.zero);

      isLoadingMarket = true;
      notifyListeners();

      await checkConnectivity(loadingField: isLoadingMarket, errorField: hasErrorMarket, notifyListeners: callNotifyListeners);

      final double mChangePercentage = await setMarketStatus();

      http.Response response = await http.get(uriMarketStatus).timeout(const Duration(seconds: 10), onTimeout: () {
        setApiFailedFields();
        throw ('Timeout: make sure your internet is working.');
      });

      ifResponseFailed(response, errorField: hasErrorMarket, loadingField: isLoadingMarket, notifyListeners: callNotifyListeners);

      await setApiCoins(response, mChangePercentage);

      isLoadingMarket = false;
      if (hasErrorMarket) hasErrorMarket = false;

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setApiCoins(http.Response response, double mChangePercentage) async {
    try {
      List<dynamic> coinsDynamic = json.decode(response.body);

      Map<String, dynamic> coinsJson = returnJsonData(coinsList: coinsDynamic);

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

      isDatabaseAvailable = true;
      notifyListeners();
    } catch (e) {
      print('$e');
    }
  }

  Future<void> getMarketStatus() async {
    try {
      final DataSnapshot mChangePercentage = await dr.child('mChangePercentage').get().timeout(const Duration(seconds: 10), onTimeout: () {
        setDbErrorFields();
        throw ('Timeout: Make sure your internet is connected.');
      });

      if (!mChangePercentage.exists) {
        setDbErrorFields();
        throw ('getting mChangePercentage failed.');
      }

      marketStatus = mChangePercentage.value as double;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<double> setMarketStatus() async {
    try {
      http.Response response = await http.get(uriApiMarketStatus).timeout(const Duration(seconds: 10), onTimeout: () {
        setMarketFailedFields();
        throw ('Timeout: make sure your internet is working.');
      });

      if (response.statusCode != 200) {
        setMarketFailedFields();
        throw ('Failed to fetch market data.');
      }

      marketStatus = addMarketStatus(response);

      return marketStatus;
    } catch (e) {
      rethrow;
    }
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

    try {
      if (coin.transactions!.length == 1) {
        await coinRef.remove();

        _userCoins.remove(coin.symbol);

        calTotalUserBalance();

        return true;
      } else {
        await transactionRef.remove();

        _userCoins[coin.symbol.toLowerCase()]!.transactions!.removeAt(transactionIndex);

        calTotalUserBalance();

        return false;
      }
    } catch (e) {
      rethrow;
    }
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
    userBalance = total;
    notifyListeners();
  }

  void callNotifyListeners() {
    notifyListeners();
  }

  Future<void> checkConnectivity({required bool loadingField, required bool errorField, required Function notifyListeners}) async {
    final ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      errorField = true;
      loadingField = false;
      notifyListeners();
      throw ('Please connect to a network and try again');
    }
  }

  void ifResponseFailed(
    http.Response response, {
    required bool loadingField,
    required bool errorField,
    required Function notifyListeners,
  }) {
    if (response.statusCode != 200) {
      loadingField = false;
      errorField = true;
      notifyListeners();

      throw ('Status code is: ${response.statusCode}');
    }
  }

  void setNullFailedFields() {
    isFirstRunUser = false;
    isLoadingUserCoin = false;
    notifyListeners();
    print('userCoins is empty in firebase.');

    return;
  }

  void setApiFailedFields() {
    isLoadingMarket = false;
    hasErrorMarket = true;
    notifyListeners();
  }

  void setMarketFailedFields() {
    isLoadingMarket = false;
    hasErrorMarket = true;
    notifyListeners();
  }

  void setDbSuccessFields() {
    isLoadingDatabase = false;
    isLoadingMarket = false;
    if (hasErrorDatabase) hasErrorDatabase = false;
    isDatabaseAvailable = true;
    isRetry = true;

    notifyListeners();
  }

  void setDbErrorFields() {
    isLoadingDatabase = false;
    hasErrorDatabase = true;
    isDatabaseAvailable = false;
    notifyListeners();
  }
}
