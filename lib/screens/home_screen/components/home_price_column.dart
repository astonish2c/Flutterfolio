import 'package:crypto_exchange_app/screens/tab_screen/widgets/tab_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/coin_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../custom_widgets/helper_methods.dart' hide calTotalCost;
import '../helper_methods.dart';

class HomePriceColumn extends StatelessWidget {
  const HomePriceColumn({
    Key? key,
    required this.coin,
  }) : super(key: key);

  final CoinModel coin;

  @override
  Widget build(BuildContext context) {
    final bool isSell = calTotalCost(coin).contains('-');

    final String totalCost = '${isSell ? '-' : ''}${currencyConverter(double.parse(calTotalCost(coin)))}';
    final String totalAmount = '${coin.symbol.toUpperCase()} ${isSell ? '-' : ''}${removeDoller(currencyConverter(double.parse(calTotalAmount(coin))))}';

    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            totalCost,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: isSell ? theme.colorScheme.error : theme.textTheme.titleMedium!.color),
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
                style: theme.textTheme.bodyMedium!.copyWith(color: isSell ? theme.colorScheme.error : theme.textTheme.bodyMedium!.color),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
