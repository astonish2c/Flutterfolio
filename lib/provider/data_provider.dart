import 'package:flutter/material.dart';

import '../model/coin_model.dart';

class DataProvider with ChangeNotifier {
  double totalUserBalance = 0.0;
  bool showPieChart = false;
  int addCoinIndex = 0;

  final Map<String, CoinModel> _allCoins = {
    DateTime.now.toString(): CoinModel(
      currentPrice: 29850.15,
      isBought: false,
      amount: 0.005,
      name: 'Bitcoin',
      shortName: 'btc',
      imageUrl: 'assets/images/bitcoin.png',
      priceDiff: '+0.9%',
      color: Colors.orange,
    ),
    'DateTime.now.toString': CoinModel(
      currentPrice: 8891.19,
      isBought: false,
      name: 'Ethereum',
      shortName: 'eth',
      imageUrl: 'assets/images/ethereum.png',
      priceDiff: '+1.2%',
      color: Colors.purple,
    ),
    'DateTime.now.toStrin': CoinModel(
      currentPrice: 221.98,
      isBought: false,
      name: 'Ripple',
      shortName: 'xrp',
      imageUrl: 'assets/images/xrp.png',
      priceDiff: '+0.5%',
      color: Colors.blue,
    ),
  };

  final Map<String, CoinModel> _userCoins = {
    'eth': CoinModel(
      currentPrice: 8891.19,
      buyPrice: 5000,
      isBought: false,
      dateTime: DateTime.now(),
      amount: 2.25,
      name: 'Ethereum',
      shortName: 'ETH',
      imageUrl: 'assets/images/ethereum.png',
      priceDiff: '+1.2%',
      color: Colors.purple,
    ),
    'xrp': CoinModel(
      currentPrice: 221.98,
      buyPrice: 150,
      isBought: false,
      dateTime: DateTime.now(),
      amount: 5,
      name: 'Ripple',
      shortName: 'xrp',
      imageUrl: 'assets/images/xrp.png',
      priceDiff: '+0.5%',
      color: Colors.blue,
    ),
  };

  List<CoinModel> get allCoins {
    return [..._allCoins.values];
  }

  List<CoinModel> get userCoins {
    return [..._userCoins.values];
  }

  void addUserCoin(CoinModel coinModel) {
    if (_userCoins.containsKey(coinModel.shortName)) {
      _userCoins.update(
        coinModel.shortName,
        (value) => CoinModel(
          currentPrice: value.currentPrice,
          buyPrice: value.buyPrice,
          amount: (coinModel.amount! + value.amount!),
          isBought: value.isBought,
          dateTime: coinModel.dateTime,
          name: value.name,
          shortName: value.shortName,
          imageUrl: value.imageUrl,
          priceDiff: value.priceDiff,
          color: value.color,
        ),
      );

      notifyListeners();
    } else {
      _userCoins.putIfAbsent(
        coinModel.shortName,
        () => CoinModel(
          currentPrice: coinModel.currentPrice,
          buyPrice: coinModel.buyPrice,
          amount: coinModel.amount,
          isBought: coinModel.isBought,
          dateTime: coinModel.dateTime,
          name: coinModel.name,
          shortName: coinModel.shortName,
          imageUrl: coinModel.imageUrl,
          priceDiff: coinModel.priceDiff,
          color: coinModel.color,
        ),
      );

      notifyListeners();
    }
  }

  void updateAddCoinIndex(int newIndex) {
    addCoinIndex = newIndex;
    notifyListeners();
  }

  void resetAddCoinIndex() {
    addCoinIndex = 0;
    notifyListeners();
  }

  void togglePieChart() {
    showPieChart = !showPieChart;
    notifyListeners();
  }

  void calculateTotalUserBalance() {
    double total = 0.0;
    for (var coinModel in userCoins) {
      total += (coinModel.buyPrice! * coinModel.amount!);
    }
    totalUserBalance = total;

    notifyListeners();
  }

  void removeItem(CoinModel coinModel) {
    _userCoins.remove(coinModel.shortName);
    notifyListeners();
  }
}
