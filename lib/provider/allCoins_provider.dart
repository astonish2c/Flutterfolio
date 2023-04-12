import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart' hide Transaction;
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../screens/home_screen/widgets/utils.dart';
import '/provider/utils/helper_methods.dart';
import '../model/coin_model.dart';

class AllCoinsProvider with ChangeNotifier {
  double marketStatus = 0.0;

  bool isFirstRun = true;

  bool isLoadingDatabase = false;
  bool hasErrorDatabase = false;
  bool isDatabaseAvailable = false;

  bool isLoadingMarket = true;
  bool hasErrorMarket = false;

  final Map<String, CoinModel> _coins = {};

  List<CoinModel> get getCoins {
    return [..._coins.values];
  }

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  final Uri uriMarketStatus = Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=1');

  final Uri uriApiMarketStatus = Uri.parse('https://api.coingecko.com/api/v3/global');

  Future<void> setDatabaseCoins() async {
    try {
      await checkConnectivity(errorField: hasErrorDatabase, loadingField: isLoadingDatabase);

      if (hasErrorDatabase) hasErrorDatabase = false;
      isLoadingDatabase = true;
      notifyListeners();

      await getMarketStatus();

      DataSnapshot marketDataSnapshot = await databaseReference.child('mChangePercentage').get();

      marketStatus = double.parse(marketDataSnapshot.value.toString());

      DataSnapshot dataSnapshot = await databaseReference.child('coins/').get();

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
      final ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        hasErrorMarket = true;
        isLoadingMarket = false;
        notifyListeners();
        throw ('Please connect to a network and try again');
      }
      await Future.delayed(Duration.zero);

      isLoadingMarket = true;
      notifyListeners();

      await checkConnectivity(loadingField: isLoadingMarket, errorField: hasErrorMarket);

      final double mChangePercentage = await setMarketStatus();

      http.Response response = await http.get(uriMarketStatus).timeout(const Duration(seconds: 10), onTimeout: () {
        setApiFailedFields();
        throw ('Timeout: make sure your internet is working.');
      });

      if (response.statusCode != 200) {
        isLoadingMarket = false;
        hasErrorMarket = true;
        notifyListeners();

        throw ('Status code is: ${response.statusCode}');
      }
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

      await databaseReference.update({'mChangePercentage': mChangePercentage});

      await databaseReference.child('coins/').update(coinsJson);

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
      Utils.showSnackBar(e.toString());
    }
  }

  Future<void> getMarketStatus() async {
    try {
      final DataSnapshot mChangePercentage = await databaseReference.child('mChangePercentage').get().timeout(const Duration(seconds: 10), onTimeout: () {
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

  void callNotifyListeners() {
    notifyListeners();
  }

  Future<void> checkConnectivity({required bool loadingField, required bool errorField}) async {
    final ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      errorField = true;
      loadingField = false;
      notifyListeners();
      throw ('Please connect to a network and try again');
    }
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
    notifyListeners();
  }

  void setDbErrorFields() {
    isLoadingDatabase = false;
    hasErrorDatabase = true;
    isDatabaseAvailable = false;
    notifyListeners();
  }
}
