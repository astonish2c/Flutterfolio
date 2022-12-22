import 'package:flutter/material.dart';

import '../model/coin_model.dart';

class DataProvider with ChangeNotifier {
  double totalUserBalance = 0.0;
  bool showPieChart = false;
  int addCoinIndex = 0;

  final Map<String, CoinModel> _allCoins = {
    DateTime.now.toString(): CoinModel(
      currentPrice: 29850.15,
      name: 'Bitcoin',
      shortName: 'btc',
      imageUrl: 'assets/images/bitcoin.png',
      priceDiff: '+0.9%',
      color: Colors.orange,
    ),
    'DateTime.now.toString': CoinModel(
      currentPrice: 8891.19,
      name: 'Ethereum',
      shortName: 'eth',
      imageUrl: 'assets/images/ethereum.png',
      priceDiff: '+1.2%',
      color: Colors.purple,
    ),
    'DateTime.now.toStrin': CoinModel(
      currentPrice: 221.98,
      name: 'Ripple',
      shortName: 'xrp',
      imageUrl: 'assets/images/xrp.png',
      priceDiff: '+0.5%',
      color: Colors.blue,
    ),
  };

  final Map<String, CoinModel> _userCoins = {
    // 'eth': CoinModel(
    //   currentPrice: 8891.19,
    //   name: 'Ethereum',
    //   shortName: 'ETH',
    //   imageUrl: 'assets/images/ethereum.png',
    //   priceDiff: '+1.2%',
    //   color: Colors.purple,
    //   buyCoin: [
    //     BuyCoin(
    //       buyPrice: 5000,
    //       amount: 2.25,
    //       dateTime: DateTime.now(),
    //     ),
    //     BuyCoin(
    //       buyPrice: 2500,
    //       amount: 5,
    //       dateTime: DateTime.now(),
    //     ),
    //     BuyCoin(
    //       buyPrice: 6000,
    //       amount: 0.5,
    //       dateTime: DateTime.now(),
    //     ),
    //   ],
    // ),
    // 'xrp': CoinModel(
    //   currentPrice: 221.98,
    //   name: 'Ripple',
    //   shortName: 'xrp',
    //   imageUrl: 'assets/images/xrp.png',
    //   priceDiff: '+0.5%',
    //   color: Colors.blue,
    //   buyCoin: [
    //     BuyCoin(
    //       buyPrice: 150,
    //       amount: 32,
    //       dateTime: DateTime.now(),
    //     ),
    //     BuyCoin(
    //       buyPrice: 120,
    //       amount: 6,
    //       dateTime: DateTime.now(),
    //     ),
    //   ],
    // ),
  };

  List<CoinModel> get allCoins {
    return [..._allCoins.values];
  }

  List<CoinModel> get userCoins {
    return [..._userCoins.values];
  }

  void removeTransaction({required CoinModel coinModel, required int buyCoinIndex, required BuildContext buildContext}) {
    _userCoins[coinModel.shortName.toLowerCase()]!.buyCoin!.removeAt(buyCoinIndex);
    if (_userCoins[coinModel.shortName.toLowerCase()]!.buyCoin!.isEmpty) {
      removeItem(coinModel);
      Navigator.of(buildContext).pop();
      notifyListeners();
    }
    notifyListeners();
  }

  void updateBuyCoin(CoinModel coinModel, int indexBuyCoin, BuyCoin returnedBuyCoin) {
    // print('index of Buy Coin at UpdateBuyCoin: $indexBuyCoin');

    final List<BuyCoin> lBuyCoin = coinModel.buyCoin!;
    lBuyCoin.removeAt(indexBuyCoin);
    lBuyCoin.insert(indexBuyCoin, returnedBuyCoin);
    notifyListeners();
  }

  void addUserCoin(CoinModel coinModel) {
    // (mini Function) Return a Joined List
    List<BuyCoin> joinTwoList({required List<BuyCoin> oldList, required List<BuyCoin> newList}) {
      oldList.addAll(newList);
      return oldList;
    }

    //Update Coin
    if (_userCoins.containsKey(coinModel.shortName)) {
      _userCoins.update(
        coinModel.shortName,
        (value) => CoinModel(
          currentPrice: value.currentPrice,
          name: value.name,
          shortName: value.shortName,
          imageUrl: value.imageUrl,
          priceDiff: value.priceDiff,
          color: value.color,
          buyCoin: joinTwoList(oldList: value.buyCoin!, newList: coinModel.buyCoin!),
          // joinTwoList(oldList: value.buyCoin!, newList: coinModel.buyCoin!).reversed.toList(),
          // buyPrice: value.buyPrice,
          // amount: (coinModel.amount! + value.amount!),
          // isBought: value.isBought,
          // dateTime: coinModel.dateTime,
        ),
      );
      notifyListeners();
    } else {
      //Add Coin
      _userCoins.putIfAbsent(
        coinModel.shortName,
        () => CoinModel(
          currentPrice: coinModel.currentPrice,
          name: coinModel.name,
          shortName: coinModel.shortName,
          imageUrl: coinModel.imageUrl,
          priceDiff: coinModel.priceDiff,
          color: coinModel.color,
          buyCoin: coinModel.buyCoin,
          // buyPrice: coinModel.buyPrice,
          // amount: coinModel.amount,
          // isBought: coinModel.isBought,
          // dateTime: coinModel.dateTime,
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

  double calTotalValue(CoinModel coinModel) {
    double totalValue = 0.0;

    for (var buyCoin in coinModel.buyCoin!) {
      totalValue += buyCoin.amount * buyCoin.buyPrice;
    }

    // notifyListeners();
    return totalValue;
  }

  String calTotalAmount(CoinModel coinModel) {
    double totalAmount = 0.0;

    for (var buyCoin in coinModel.buyCoin!) {
      totalAmount += buyCoin.amount;
    }

    return totalAmount.toString();
  }

  void calTotalUserBalance() {
    double total = 0.0;
    for (var coinModel in userCoins) {
      for (var buyCoin in coinModel.buyCoin!) {
        total += buyCoin.amount * buyCoin.buyPrice;
      }
    }
    totalUserBalance = total;
    // print('total user balance in DataProvider is: $totalUserBalance');
    notifyListeners();
  }

  void removeItem(CoinModel coinModel) {
    _userCoins.remove(coinModel.shortName);
    notifyListeners();
  }
}
