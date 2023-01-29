import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CoinModel {
  double currentPrice;
  final String name;
  final String shortName;
  final String imageUrl;
  final Color color;
  final String priceDiff;
  final List<Transaction>? transactions;

  CoinModel({
    required this.currentPrice,
    required this.name,
    required this.shortName,
    required this.imageUrl,
    required this.priceDiff,
    required this.color,
    this.transactions,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      currentPrice: double.parse(json["current_price"].toString()),
      name: json["id"],
      shortName: json["symbol"],
      imageUrl: json['image'],
      priceDiff: json["price_change_percentage_24h"].toString(),
      color: Colors.blue,
    );
  }
}

class Transaction {
  final double buyPrice;
  final double amount;
  final DateTime dateTime;
  final String? id;

  Transaction({
    required this.buyPrice,
    required this.amount,
    required this.dateTime,
    this.id,
  });
}
