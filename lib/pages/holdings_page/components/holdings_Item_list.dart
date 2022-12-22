import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../utils/constants.dart';

class HoldingsItemList extends StatelessWidget {
  final CoinModel coinModel;

  const HoldingsItemList({
    super.key,
    required this.coinModel,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: defaultPadding),
      child: Dismissible(
        dismissThresholds: const {
          DismissDirection.endToStart: 0.3,
        },
        background: Container(
          constraints: const BoxConstraints(maxWidth: 50),
          margin: EdgeInsets.only(left: defaultPadding),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 45,
          ),
        ),
        key: ValueKey('item ${coinModel.shortName}'),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Remove Item',
                  style: textTheme.titleMedium!.copyWith(fontSize: 20),
                ),
                content: RichText(
                  text: TextSpan(
                    style: textTheme.titleSmall,
                    children: [
                      const TextSpan(text: 'Are you sure to remove '),
                      TextSpan(
                        text: coinModel.shortName.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' from Portfolio?'),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (_) {
          Provider.of<DataProvider>(context, listen: false).removeItem(coinModel);
          Provider.of<DataProvider>(context, listen: false).calTotalUserBalance();
        },
        child: Row(
          children: [
            //Icon
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(coinModel.imageUrl),
            ),
            SizedBox(width: defaultPadding),
            //Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coinModel.shortName.toUpperCase(),
                  style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: defaultPadding / 4),
                Text(
                  coinModel.name,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
            const Spacer(),
            //Total amount & value
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //Total Amount
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Consumer<DataProvider>(
                    builder: (context, value, child) => Text(
                      value.calTotalAmount(coinModel),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                //Total Value
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Consumer<DataProvider>(
                    builder: (context, value, child) => Text(
                      '\$${convertStrToNum(value.calTotalValue(coinModel))}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
