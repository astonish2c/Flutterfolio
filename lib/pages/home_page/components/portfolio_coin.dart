import 'package:flutter/material.dart';

import '../../../model/coin_model.dart';
import '../../../utils/constants.dart';
import 'portfolio_price_column.dart';

class PortfolioCoin extends StatelessWidget {
  const PortfolioCoin({
    required this.coin,
    Key? key,
  }) : super(key: key);

  final CoinModel coin;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.network(coin.image),
              ),
              SizedBox(width: defaultPadding),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coin.name.toCapitalized(), style: theme.textTheme.titleMedium),
                  SizedBox(height: defaultPadding / 4),
                  Text(coin.symbol.toUpperCase(), style: theme.textTheme.bodyMedium),
                ],
              ),
              const Spacer(),
              PortfolioPriceColumn(coin: coin),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
