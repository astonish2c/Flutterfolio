import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/tab_screen/tab_screen.dart';
import '../../custom_widgets/custom_icon_btn.dart';
import 'components/transactions_bottom_sheet.dart';
import '../../custom_widgets/helper_methods.dart';
import '../../model/coin_model.dart';
import '../../provider/data_provider.dart';
import '../../provider/theme_provider.dart';
import '../../custom_widgets/custom_big_btn.dart';
import 'components/transactions_item.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key, this.coin});

  static const routeName = 'CoinDetailScreen';
  final CoinModel? coin;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    void popPage() {
      if (!context.mounted) return;

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
              child: Image.network(coin!.image),
            ),
            const SizedBox(width: 4),
            Text(
              coin!.symbol.toUpperCase(),
              style: textTheme.titleMedium!.copyWith(fontSize: 18),
            ),
            const SizedBox(width: 4),
            Text(
              coin!.name.toCapitalized(),
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
              child: Builder(builder: (context) {
                context.watch<DataProvider>().userCoins;

                return ListView.builder(
                    itemCount: coin!.transactions!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          child: TransactionsItem(coin: coin!, transaction: coin!.transactions![index]),
                          onTap: () async {
                            await showModalBottomSheet(
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                                ),
                                context: context,
                                builder: (context) {
                                  return TransactionsBottomSheet(coinModel: coin!, index: index, popPage: popPage);
                                });
                          });
                    });
              }),
            ),
            const SizedBox(height: 16),
            CustomBigBtn(
                text: 'Add Transaction',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TabScreen(coinModel: coin, pushHomePage: false, initialPage: 0),
                    ),
                  );
                }),
          ]),
        ),
      ),
    );
  }
}
