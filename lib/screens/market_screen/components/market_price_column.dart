import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/coin_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../custom_widgets/helper_methods.dart';

class MarketPriceColumn extends StatelessWidget {
  const MarketPriceColumn({
    Key? key,
    required this.coin,
  }) : super(key: key);

  final CoinModel coin;

  @override
  Widget build(BuildContext context) {
    bool isNegative = double.parse(coin.priceDiff).isNegative;

    String priceStatus = '${isNegative ? '' : '+'}${convertPerToNum(coin.priceDiff)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            currencyConverter(coin.currentPrice, isCurrency: true),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(height: 16 / 4),
        Consumer<ThemeProvider>(
          builder: (context, value, child) => FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isNegative ? Colors.red[300] : Colors.green[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                priceStatus,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
