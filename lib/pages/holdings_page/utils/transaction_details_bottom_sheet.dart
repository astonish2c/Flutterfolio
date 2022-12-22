import 'package:crypto_exchange_app/pages/holdings_page/utils/transaction_details_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../utils/constants.dart';
import '../../exchange_page/components/exchange_big_btn.dart';
import '../../home_page/components/home_tab_bar.dart';

class TransactionDetailsBottomSheet extends StatelessWidget {
  const TransactionDetailsBottomSheet({
    Key? key,
    required this.coinModel,
    required this.index,
    required this.dataProvider,
  }) : super(key: key);

  final CoinModel coinModel;
  final DataProvider dataProvider;

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
          //Type
          const TransactionDetailsRow(
            title1: 'Type',
            title2: 'Buy',
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          TransactionDetailsRow(
            title1: 'Date',
            title2: DateFormat('d, MMM, y, h:m a').format(coinModel.buyCoin![index].dateTime),
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          TransactionDetailsRow(
            title1: 'Price Per Coin',
            title2: '\$${convertStrToNum(coinModel.buyCoin![index].buyPrice)}',
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          TransactionDetailsRow(
            title1: 'Quantity',
            title2: coinModel.buyCoin![index].amount.toString(),
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          const TransactionDetailsRow(
            title1: 'Fee',
            title2: 'No Fee',
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          TransactionDetailsRow(
            title1: 'Total Cost',
            title2: '\$${convertStrToNum(coinModel.buyCoin![index].amount * coinModel.buyCoin![index].buyPrice)}',
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeTabBar(coinModel: coinModel, indexBuyCoin: index)));
            },
          ),
          const SizedBox(height: 8),
          ExchnageBigBtn(
            text: 'Remove Transaction',
            bgColor: Colors.red[900],
            textColor: Colors.white,
            onTap: () {
              dataProvider.removeTransaction(coinModel: coinModel, buyCoinIndex: index, buildContext: context);
              dataProvider.calTotalUserBalance();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
