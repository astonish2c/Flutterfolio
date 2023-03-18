import 'package:crypto_exchange_app/pages/market_page/components/market_price_column.dart';
import 'package:flutter/material.dart';

import '../../../model/coin_model.dart';
import '../../../utils/constants.dart';

class MarketCoinRow extends StatelessWidget {
  const MarketCoinRow({
    required this.coinModel,
    Key? key,
  }) : super(key: key);

  final CoinModel coinModel;

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
                child: Image.network(coinModel.image),
              ),
              SizedBox(width: defaultPadding),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coinModel.name.toCapitalized(), style: theme.textTheme.titleMedium),
                  SizedBox(height: defaultPadding / 4),
                  Text(coinModel.symbol.toUpperCase(), style: theme.textTheme.bodyMedium),
                ],
              ),
              const Spacer(),
              MarketPriceColumn(cm: coinModel),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
