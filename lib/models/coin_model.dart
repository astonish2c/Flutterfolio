class CoinModel {
  final double currentPrice;
  final String name;
  final String symbol;
  final String image;
  final String priceDiff;
  final List<Transaction>? transactions;
  final int? market_cap_rank;

  CoinModel({
    required this.currentPrice,
    required this.name,
    required this.symbol,
    required this.image,
    required this.priceDiff,
    this.transactions,
    this.market_cap_rank,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      currentPrice: double.parse(json["current_price"].toString()),
      name: json["name"],
      symbol: json["symbol"],
      image: json['image'],
      priceDiff: json["price_change_percentage_24h"].toString(),
      market_cap_rank: json["market_cap_rank"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_price': currentPrice,
      'name': name,
      'symbol': symbol,
      'image': image,
      'price_change_percentage_24h': priceDiff,
      "market_cap_rank": market_cap_rank,
    };
  }
}

class Transaction {
  final double buyPrice;
  final double amount;
  final DateTime dateTime;
  final String? id;
  final bool isSell;

  Transaction({
    required this.buyPrice,
    required this.amount,
    required this.dateTime,
    this.id,
    this.isSell = false,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      buyPrice: double.parse(json['buyPrice'].toString()),
      amount: double.parse(json['amount'].toString()),
      dateTime: DateTime.parse(json['dateTime']),
      id: json['id'],
      isSell: json['isSell'],
    );
  }

  Transaction addId(Transaction transaction, String id) {
    return Transaction(
      buyPrice: transaction.buyPrice,
      amount: transaction.amount,
      dateTime: transaction.dateTime,
      id: id,
      isSell: transaction.isSell,
    );
  }

  Transaction addIsSell(Transaction transaction, bool isSell) {
    return Transaction(
      buyPrice: transaction.buyPrice,
      amount: transaction.amount,
      dateTime: transaction.dateTime,
      id: id,
      isSell: isSell,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      id!: {
        'buyPrice': buyPrice,
        'amount': amount,
        'dateTime': dateTime.toIso8601String(),
        'id': id,
        'isSell': isSell,
      }
    };
  }
}
