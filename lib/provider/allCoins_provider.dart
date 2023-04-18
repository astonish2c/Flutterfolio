// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart' hide Transaction;
import 'package:http/http.dart' as http;

import '../Auth/widgets/utils.dart';
import '/provider/utils/helper_methods.dart';
import '../models/coin_model.dart';

class AllCoinsProvider with ChangeNotifier {
  double _marketStatus = 0.0;

  bool _isDatabaseAvailable = false;
  bool _isFirstRun = true;
  bool _isLoadingMarket = true;

  final Map<String, CoinModel> _coins = {};

  List<CoinModel> get getCoins {
    return [..._coins.values];
  }

  get getIsDatabaseAvailable {
    return _isDatabaseAvailable;
  }

  get getMarketStatus {
    return _marketStatus;
  }

  get getIsFirstRun {
    return _isFirstRun;
  }

  get getIsLoadingMarket {
    return _isLoadingMarket;
  }

  void setIsFirstRun(bool isFirstRun) {
    _isFirstRun = isFirstRun;
    notifyListeners();
  }

  void setIsLoadingMarket(bool isLoadingMarket) {
    _isLoadingMarket = isLoadingMarket;
    notifyListeners();
  }

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  final Uri uriCoins = Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=1');

  final Uri uriMarketStatus = Uri.parse('https://api.coingecko.com/api/v3/global');

  Future<void> setDatabaseData() async {
    try {
      final DataSnapshot dsMarketStatus = await databaseReference.child('mChangePercentage').get();

      DataSnapshot dsCoins = await databaseReference.child('coins/').get();

      if (!dsCoins.exists || !dsMarketStatus.exists) return print('Data not available at Firebase DB.');

      addDatabaseCoins(dsCoins: dsCoins, coins: _coins);

      _marketStatus = double.parse(dsMarketStatus.value.toString());

      _isFirstRun = false;
      _isLoadingMarket = false;
      _isDatabaseAvailable = true;

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getApiData() async {
    try {
      print('getApiData called');
      final http.Response rMarketStatus = await http.get(uriMarketStatus);
      if (rMarketStatus.statusCode != 200) throwError(response: rMarketStatus, errorMessage: 'Get API marketStatus failed: ', fields: [_isLoadingMarket]);

      final http.Response rCoins = await http.get(uriCoins);
      if (rCoins.statusCode != 200) throwError(response: rCoins, errorMessage: 'Get API coins failed: ', fields: [_isLoadingMarket]);

      await setApiData(rCoins, rMarketStatus);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setApiData(http.Response rCoins, http.Response rMarketStatus) async {
    try {
      _marketStatus = addMarketStatus(rMarketStatus);

      List<dynamic> coinsDynamic = json.decode(rCoins.body);

      Map<String, dynamic> coinsJson = returnJsonData(coinsList: coinsDynamic);

      await databaseReference.update({'mChangePercentage': _marketStatus});

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
      _isDatabaseAvailable = true;
      _isFirstRun = false;
      _isLoadingMarket = false;
      notifyListeners();
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  void throwError({http.Response? response, String? errorMessage, required List<bool> fields}) {
    for (var field in fields) {
      field = false;
    }
    notifyListeners();
    throw ('$errorMessage: ${response?.statusCode}');
  }
}
