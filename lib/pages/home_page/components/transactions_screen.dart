import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/pages/home_page/components/bottom_sheet.dart';
import '/pages/home_page/components/home_tab_bar.dart';
import '/utils/constants.dart';
import '/utils/custom_icon_button.dart';
import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utils/exchange_big_btn.dart';
import 'transaction_row.dart';

class TransactionsScreen extends StatelessWidget {
  static const routeName = 'CoinDetailScreen';
  final CoinModel? coinModel;

  const TransactionsScreen({
    super.key,
    this.coinModel,
  });

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = context.watch<DataProvider>();
    final TextTheme textTheme = Theme.of(context).textTheme;

    var filteredCM = dataProvider.allCoins.where((element) => element.symbol == coinModel!.symbol).toList();
    var cm = filteredCM[0];

    void popPage() {
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Consumer<ThemeProvider>(
          builder: (context, value, child) => CustomIconButton(
            icon: Icons.arrow_back_ios,
            color: value.isDark ? Colors.white : Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: Image.network(coinModel!.image),
            ),
            const SizedBox(width: 4),
            Text(
              coinModel!.symbol.toUpperCase(),
              style: textTheme.titleMedium!.copyWith(fontSize: 18),
            ),
            const SizedBox(width: 4),
            Text(
              coinModel!.name.toCapitalized(),
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Transactions',
              style: textTheme.titleMedium!.copyWith(fontSize: 22),
            ),
            SizedBox(height: defaultPadding),
            Expanded(
              child: ListView.builder(
                  itemCount: coinModel!.transactions!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        child: TransactionRow(coinModel: coinModel!, transaction: coinModel!.transactions![index]),
                        onTap: () async {
                          await showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return TransactionBottomSheet(coinModel: coinModel!, index: index, dataProvider: dataProvider, popPage: popPage);
                              });
                        });
                  }),
            ),
            const SizedBox(height: 16),
            ExchnageBigBtn(
                text: 'Add Transaction',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomeTabBar(coinModel: cm, pushHomePage: false, initialPage: 0),
                    ),
                  );
                }),
          ]),
        ),
      ),
    );
  }
}
