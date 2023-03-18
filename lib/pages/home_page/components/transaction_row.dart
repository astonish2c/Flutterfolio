import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../model/coin_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../utils/constants.dart';

class TransactionRow extends StatelessWidget {
  const TransactionRow({
    Key? key,
    required this.coinModel,
    required this.transaction,
  }) : super(key: key);

  final CoinModel coinModel;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    String value = '${transaction.isSell ? '-' : '+'}\$${convertStrToNum(transaction.buyPrice * transaction.amount)}';
    String amount = '${transaction.isSell ? '-' : '+'}${transaction.amount.toString().removeTrailingZeros()} ${coinModel.symbol.toUpperCase()}';

    Color bgColorDay = transaction.isSell ? Colors.red : Colors.green;

    return Column(children: [
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
                  color: value.isDark ? Colors.white : Colors.black,
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
                    value,
                    style: textTheme.titleMedium,
                  ),
                  Text(
                    amount,
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
      SizedBox(height: defaultPadding / 2),
    ]);
  }
}
