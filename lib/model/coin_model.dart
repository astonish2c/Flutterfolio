import 'package:flutter/material.dart';

class CoinModel {
  double currentPrice;
  final String name;
  final String shortName;
  final String imageUrl;
  final Color color;
  final String priceDiff;
  double? buyPrice;
  double? amount;
  bool? isBought;
  DateTime? dateTime;

  CoinModel({
    required this.currentPrice,
    required this.name,
    required this.shortName,
    required this.imageUrl,
    required this.priceDiff,
    required this.color,
    this.buyPrice,
    this.dateTime,
    this.amount,
    this.isBought,
  });

  // CoinModel.buy({
  //   required double this.buyPrice,

  // });
}
