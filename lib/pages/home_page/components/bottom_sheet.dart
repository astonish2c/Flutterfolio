import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:crypto_exchange_app/pages/home_page/components/bottom_sheet_row.dart';
import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/exchange_big_btn.dart';
import 'home_tab_bar.dart';
import 'package:provider/provider.dart';

class TransactionBottomSheet extends StatefulWidget {
  const TransactionBottomSheet({Key? key, required this.coinModel, required this.index, required this.popPage}) : super(key: key);

  final CoinModel coinModel;
  final Function popPage;
  final int index;

  @override
  State<TransactionBottomSheet> createState() => _TransactionBottomSheetState();
}

class _TransactionBottomSheetState extends State<TransactionBottomSheet> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Transaction transaction = widget.coinModel.transactions![widget.index];

    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 32),
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
            title2: transaction.isSell ? 'Sell' : 'Buy',
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          BottomSheetRow(
            title1: 'Date',
            title2: DateFormat('d, MMM, y, h:m a').format(transaction.dateTime),
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          BottomSheetRow(
            title1: 'Price Per Coin',
            title2: numToCurrency(num: transaction.buyPrice, isCuurency: true),
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          BottomSheetRow(
            title1: 'Quantity',
            title2: transaction.amount.toString().removeTrailingZeros(),
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
            title2: numToCurrency(num: transaction.amount * transaction.buyPrice, isCuurency: true),
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
              if (transaction.isSell) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeTabBar(coinModel: widget.coinModel, indexTransaction: widget.index, initialPage: 1)));
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeTabBar(coinModel: widget.coinModel, indexTransaction: widget.index, initialPage: 0)));
              }
            },
          ),
          const SizedBox(height: 8),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ExchnageBigBtn(
                  text: 'Remove Transaction',
                  bgColor: Colors.red[900],
                  textColor: Colors.white,
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });

                    final bool lastTransaction = await context.read<DataProvider>().removeTransaction(coin: widget.coinModel, transactionIndex: widget.index);

                    if (context.mounted) Navigator.of(context).pop();

                    if (lastTransaction != true) return;

                    widget.popPage();
                  },
                ),
        ],
      ),
    );
  }
}
