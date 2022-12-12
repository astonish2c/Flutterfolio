import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../utils/constants.dart';

class HoldingsBalance extends StatelessWidget {
  final CoinModel coinModel;

  const HoldingsBalance({
    super.key,
    required this.coinModel,
  });

  //List Item Row
  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);

    return Padding(
      padding: EdgeInsets.only(bottom: defaultPadding),
      child: Dismissible(
        background: Container(
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
                title: const Text(
                  'Remove Item',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                content: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                    ),
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
          dataProvider.calculateTotalUserBalance();
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
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: defaultPadding / 4),
                Text(
                  coinModel.name,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            //Date
            // Expanded(
            //   child: Text(
            //     textAlign: TextAlign.center,
            //     DateFormat('y-MMM-d H:M a').format(coinModel.dateTime!),
            //   ),
            // ),
            //Price Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    coinModel.amount.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "\$${convertStrToNum(coinModel.buyPrice! * coinModel.amount!)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
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
