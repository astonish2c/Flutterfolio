import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/tab_screen/widgets/tab_screen_mixin.dart';
import '../../../models/coin_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../custom_widgets/helper_methods.dart' hide calTotalCost;
import '../widgets/helper_methods.dart';

class PortfolioPriceColumn extends StatelessWidget {
  const PortfolioPriceColumn({
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
        const SizedBox(height: 4),
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
