import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/coin_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../utils/constants.dart';

class HomePriceColumn extends StatelessWidget {
  const HomePriceColumn({
    Key? key,
    required this.cm,
  }) : super(key: key);

  final CoinModel cm;

  @override
  Widget build(BuildContext context) {
    double coinAmount = 0.0;
    double totalValue = 0.0;

    List<Transaction> transactions = cm.transactions as List<Transaction>;

    for (var transaction in transactions) {
      if (transaction.isSell) {
        coinAmount -= transaction.amount;
        totalValue -= transaction.buyPrice * transaction.amount;
      } else {
        coinAmount += transaction.amount;
        totalValue += transaction.buyPrice * transaction.amount;
      }
    }

    String readyTotalValue = '\$${convertStrToNum(totalValue)}';
    String readyCoinAmount = '${cm.symbol.toUpperCase()} ${coinAmount.toString().removeTrailingZeros()}'.toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            readyTotalValue,
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
                readyCoinAmount,
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
