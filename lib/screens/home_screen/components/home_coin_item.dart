import 'package:flutter/material.dart';

import '../../../model/coin_model.dart';
import '../../../custom_widgets/helper_methods.dart';
import 'home_price_column.dart';

class HomeCoinItem extends StatelessWidget {
  const HomeCoinItem({
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
          padding: const EdgeInsets.symmetric(vertical: 16 / 2),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.network(
                  coin.image,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/no-wifi.png',
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coin.name.toCapitalized(), style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16 / 4),
                  Text(coin.symbol.toUpperCase(), style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimaryContainer.withOpacity(0.4))),
                ],
              ),
              const Spacer(),
              HomePriceColumn(coin: coin),
            ],
          ),
        ),
        const Divider(thickness: 0.2),
      ],
    );
  }
}
