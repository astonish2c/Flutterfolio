import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/coin_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../custom_widgets/helper_methods.dart';

class TransactionsItem extends StatelessWidget {
  const TransactionsItem({
    Key? key,
    required this.coin,
    required this.transaction,
  }) : super(key: key);

  final CoinModel coin;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final Color bgColorDay = transaction.isSell ? Colors.red : Colors.green;

    final String totalCost = '${transaction.isSell ? '-' : '+'}${currencyConverter(transaction.amount * transaction.buyPrice)}';
    final String totalAmount = '${transaction.isSell ? '-' : '+'}${currencyConverter(transaction.amount, isCurrency: false)}';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Consumer<ThemeProvider>(
                builder: (context, value, child) => Container(
                  padding: const EdgeInsets.only(left: 4, top: 6, bottom: 6, right: 4),
                  decoration: BoxDecoration(
                    color: bgColorDay,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    transaction.isSell ? Icons.arrow_upward : Icons.arrow_downward_rounded,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, left: 4),
                      child: Text(
                        transaction.isSell ? 'Sell' : 'Buy',
                        textAlign: TextAlign.start,
                        style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        DateFormat('E, MMM d, y, h:m a').format(transaction.dateTime),
                        textAlign: TextAlign.start,
                        style: textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      totalCost,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      totalAmount,
                      style: textTheme.bodyMedium!.copyWith(color: bgColorDay, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey.withOpacity(0.2),
          thickness: 1,
        ),
        SizedBox(height: 16 / 2),
      ],
    );
  }
}
