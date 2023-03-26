import 'package:crypto_exchange_app/pages/home_page/components/sell_tab.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:crypto_exchange_app/pages/home_page/components/bottom_sheet_row.dart';
import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/exchange_big_btn.dart';
import 'home_tab_bar.dart';
import 'package:provider/provider.dart';

class TransactionBottomSheet extends StatelessWidget {
  const TransactionBottomSheet({
    Key? key,
    required this.coinModel,
    required this.index,
    // required this.dataProvider,
    required this.popPage,
  }) : super(key: key);

  final CoinModel coinModel;
  // final DataProvider dataProvider;
  final Function popPage;
  final int index;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.only(left: defaultPadding * 1.5, right: defaultPadding * 1.5, bottom: defaultPadding * 1.5, top: defaultPadding * 2),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Transaction Details',
            style: textTheme.titleMedium!.copyWith(fontSize: 20),
          ),
          SizedBox(height: defaultPadding),
          BottomSheetRow(
            title1: 'Type',
            title2: coinModel.transactions![index].isSell ? 'Sell' : 'Buy',
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          BottomSheetRow(
            title1: 'Date',
            title2: DateFormat('d, MMM, y, h:m a').format(coinModel.transactions![index].dateTime),
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          BottomSheetRow(
            title1: 'Price Per Coin',
            title2: '\$${convertStrToNum(coinModel.transactions![index].buyPrice)}',
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          BottomSheetRow(
            title1: 'Quantity',
            title2: coinModel.transactions![index].amount.toString().removeTrailingZeros(),
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          const BottomSheetRow(
            title1: 'Fee',
            title2: 'No Fee',
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          BottomSheetRow(
            title1: 'Total Cost',
            title2: '\$${convertStrToNum(coinModel.transactions![index].amount * coinModel.transactions![index].buyPrice)}',
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          ExchnageBigBtn(
            text: 'Edit Transaction',
            bgColor: Colors.blue[900],
            textColor: Colors.white,
            onTap: () {
              Navigator.of(context).pop();
              if (coinModel.transactions![index].isSell) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeTabBar(coinModel: coinModel, indexTransaction: index, initialPage: 1)));
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeTabBar(coinModel: coinModel, indexTransaction: index, initialPage: 0)));
              }
            },
          ),
          const SizedBox(height: 8),
          ExchnageBigBtn(
            text: 'Remove Transaction',
            bgColor: Colors.red[900],
            textColor: Colors.white,
            onTap: () async {
              final bool value = await context.read<DataProvider>().removeTransaction(coin: coinModel, transactionIndex: index);

              Navigator.of(context).pop();

              if (value != true) return;

              popPage();
            },
          ),
        ],
      ),
    );
  }
}
