import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/coin_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../utils/constants.dart';

class PortfolioPriceColumn extends StatelessWidget {
  const PortfolioPriceColumn({
    Key? key,
    required this.coin,
  }) : super(key: key);

  final CoinModel coin;

  @override
  Widget build(BuildContext context) {
    double sumAmount = 0.0;
    double sumCost = 0.0;

    for (var transaction in coin.transactions!) {
      final t = transaction;

      if (t.isSell) {
        sumAmount -= t.amount;
        sumCost -= t.buyPrice * t.amount;
      } else {
        sumAmount += t.amount;
        sumCost += t.buyPrice * t.amount;
      }
    }

    String totalCost = currencyConverter(sumCost);

    String totalAmount = '${coin.symbol.toUpperCase()} ${currencyConverter(sumAmount, isCurrency: false)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            totalCost,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(height: defaultPadding / 4),
        Consumer<ThemeProvider>(
          builder: (context, value, child) => FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                totalAmount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
