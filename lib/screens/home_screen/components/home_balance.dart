import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/data_provider.dart';
import '../../../custom_widgets/helper_methods.dart';

class HomeBalance extends StatefulWidget {
  const HomeBalance({Key? key}) : super(key: key);

  @override
  State<HomeBalance> createState() => _HomeBalanceState();
}

class _HomeBalanceState extends State<HomeBalance> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final bool isSellMore = context.select((DataProvider dataProvider) => dataProvider.isSellMore);
    final double userBalance = context.select((DataProvider dataProvider) => dataProvider.userBalance);

    final userBalanceSet = userBalance == 0 ? '\$0.00' : currencyConverter(userBalance);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.colorScheme.primaryContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Balance',
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              isSellMore ? '-$userBalanceSet' : userBalanceSet,
              maxLines: 1,
              style: theme.textTheme.titleLarge!.copyWith(fontSize: 32),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
