import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/coin_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../custom_widgets/helper_methods.dart';
import '../helper_methods.dart';

class HomePriceColumn extends StatelessWidget {
  const HomePriceColumn({
    Key? key,
    required this.coin,
  }) : super(key: key);

  final CoinModel coin;

  @override
  Widget build(BuildContext context) {
    final String totalCost = currencyConverter(double.parse(calTotalCost(coin)));
    final String totalAmount = '${coin.symbol.toUpperCase()} ${currencyConverter(double.parse(calTotalCost(coin)), isCurrency: false)}';

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
