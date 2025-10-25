import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' hide Transaction;
import 'package:flutter/material.dart';

import '../Auth/widgets/utils.dart';
import '../models/coin_model.dart';
import 'utils/helper_methods.dart';

class UserCoinsProvider with ChangeNotifier {
  double userBalance = 0.0;
  bool isFirstRunUser = true;
  bool isSellMore = false;
  bool isLoadingUserCoin = true;
  bool hasErrorUserCoin = false;

  User? _user;
  User? get user => _user;
  void updateUser(User newUser) => _user = newUser;

  void resetUser() {
    _userCoins.clear();
    userBalance = 0.0;
    isFirstRunUser = true;
    isSellMore = false;
    isLoadingUserCoin = true;
    hasErrorUserCoin = false;

    // cancel any active listeners/timers
    _userCoinsSub?.cancel();
    _userCoinsSub = null;
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  final Map<String, CoinModel> _userCoins = {};
  List<CoinModel> get userCoins => [..._userCoins.values];

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  // store subscription + debounce timer
  StreamSubscription<DatabaseEvent>? _userCoinsSub;
  Timer? _debounceTimer;

  void listenUserCoins() {
    // avoid adding duplicate listeners
    _userCoinsSub?.cancel();

    _userCoinsSub = databaseReference
        .child('userCoins/${user?.uid}/')
        .onValue
        .listen(
          (event) {
            // debounce rapid events
            _debounceTimer?.cancel();
            _debounceTimer = Timer(const Duration(milliseconds: 200), () {
              _handleUserCoinsEvent(event);
            });
          },
          onError: (err) {
            // handle errors gracefully
            hasErrorUserCoin = true;
            isLoadingUserCoin = false;
            notifyListeners();
            Utils.showSnackBar(err.toString());
            print('Error listening to user coins: $err');
          },
        );
  }

  void _handleUserCoinsEvent(DatabaseEvent data) {
    if (data.snapshot.value == null) {
      isFirstRunUser = false;
      isLoadingUserCoin = false;
      notifyListeners();
      return;
    }

    // ensure addFetchedUserCoins is efficient and non-blocking
    addFetchedUserCoins(event: data, userCoins: _userCoins);

    isFirstRunUser = false;
    isLoadingUserCoin = false;

    calTotalUserBalance();
  }

  @override
  void dispose() {
    _userCoinsSub?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> addTransaction(CoinModel coin) async {
    if (_userCoins.containsKey(coin.symbol)) {
      await addAsSingleTransaction(coin);
    } else {
      await addAsNewCoin(coin);
    }
  }

  Future<void> addAsNewCoin(CoinModel coin) async {
    DatabaseReference coinRef = FirebaseDatabase.instance.ref('userCoins/${user?.uid}/${coin.symbol}');

    final String transactionId = coinRef.push().key as String;

    final Transaction transaction = coin.transactions![0].addId(coin.transactions![0], transactionId);

    await coinRef.set({'current_price': coin.currentPrice, 'name': coin.name, 'symbol': coin.symbol, 'image': coin.image, 'price_change_percentage_24h': coin.priceDiff, 'transactions': transaction.toJson()});

    _userCoins.putIfAbsent(coin.symbol, () => CoinModel(currentPrice: coin.currentPrice, name: coin.name, symbol: coin.symbol, image: coin.image, priceDiff: coin.priceDiff, transactions: [transaction]));
    calTotalUserBalance();
  }

  Future<void> addAsSingleTransaction(CoinModel coin) async {
    DatabaseReference transactionsRef = FirebaseDatabase.instance.ref('userCoins/${user?.uid}/${coin.symbol}/transactions');

    final String transactionId = transactionsRef.push().key as String;

    final Transaction transaction = coin.transactions![0].addId(coin.transactions![0], transactionId);

    try {
      await transactionsRef.update(transaction.toJson());

      _userCoins.update(coin.symbol, (coin) {
        coin.transactions!.add(transaction);

        return CoinModel(currentPrice: coin.currentPrice, name: coin.name, symbol: coin.symbol, image: coin.image, priceDiff: coin.priceDiff, transactions: coin.transactions);
      });

      calTotalUserBalance();
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  Future<void> updateTransaction(CoinModel coin, int transactionIndex, Transaction transaction) async {
    final String transactionId = coin.transactions![transactionIndex].id as String;

    DatabaseReference transactionRef = FirebaseDatabase.instance.ref('userCoins/${user?.uid}/${coin.symbol}/transactions/');

    Transaction assignedId = transaction.addId(transaction, transactionId);

    await transactionRef.update(assignedId.toJson());

    coin.transactions!.removeAt(transactionIndex);
    coin.transactions!.insert(transactionIndex, assignedId);

    calTotalUserBalance();
  }

  Future<bool> removeTransaction({required CoinModel coin, required int transactionIndex}) async {
    final List<Transaction> transactions = coin.transactions as List<Transaction>;

    final String transactionId = transactions[transactionIndex].id as String;

    final DatabaseReference coinRef = FirebaseDatabase.instance.ref('userCoins/${user?.uid}/${coin.symbol}');
    final DatabaseReference transactionRef = FirebaseDatabase.instance.ref('userCoins/${user?.uid}/${coin.symbol}/transactions/$transactionId');

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
}
