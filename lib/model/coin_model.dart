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
