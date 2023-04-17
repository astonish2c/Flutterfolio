import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../custom_widgets/helper_methods.dart';
import '../../../provider/allCoins_provider.dart';

class MarketStatusSection extends StatelessWidget {
  const MarketStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final double marketStatus = context.select((AllCoinsProvider allCoinsProvider) => allCoinsProvider.getMarketStatus);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              marketStatus < 0 ? 'Market is down' : 'Market is up',
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium!.copyWith(fontSize: 26, letterSpacing: 1.1),
            ),
            Text(
              'in the past 24 hours',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: marketStatus < 0 ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            marketStatus < 0 ? '${convertPerToNum(marketStatus.toString())}%' : '+${convertPerToNum(marketStatus.toString())}%',
            style: theme.textTheme.bodyMedium!.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
