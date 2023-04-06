import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart' hide Transaction;
import 'package:flutter/material.dart';

import '../model/coin_model.dart';
import 'utils/helper_methods.dart';

class UserCoinsProvider with ChangeNotifier {
  double userBalance = 0.0;

  bool isFirstRunUser = true;

  bool isSellMore = false;

  bool isLoadingUserCoin = false;
  bool hasErrorUserCoin = false;

  final Map<String, CoinModel> _userCoins = {};

  List<CoinModel> get userCoins {
    return [..._userCoins.values];
  }

  DatabaseReference dr = FirebaseDatabase.instance.ref();

  Future<void> setUserCoin() async {
    final ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      hasErrorUserCoin = true;
      isLoadingUserCoin = false;
      notifyListeners();
      throw ('Please connect to a network and try again');
    }

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

  Future<void> addUserCoin(CoinModel coinModel) async {
    final String coinUrl = 'userCoins/${coinModel.symbol}';
    final String symbol = coinModel.symbol;

    if (_userCoins.containsKey(coinModel.symbol)) {
      await addTransaction(coinModel.transactions![0], coinUrl, symbol);
    } else {
      await addCoin(coinModel);
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

  List<Transaction> getTransactions({required CoinModel coin}) {
    return _userCoins[coin.symbol]!.transactions!;
  }

  void calTotalUserBalance() {
    double totalBuy = 0.0;

    double totalSell = 0.0;

    for (var coin in userCoins) {
      for (var transaction in coin.transactions!) {
        if (transaction.isSell) {
          totalSell += transaction.amount * transaction.buyPrice;
        } else {
          totalBuy += transaction.amount * transaction.buyPrice;
        }
      }
    }

    double result = totalBuy - totalSell;

    userBalance = result;

    if (result.toString().contains('-')) {
      isSellMore = true;
    } else {
      isSellMore = false;
    }
    notifyListeners();
  }

  void setNullFailedFields() {
    isFirstRunUser = false;
    isLoadingUserCoin = false;
    notifyListeners();
    print('userCoins is empty in firebase.');

    return;
  }
}
