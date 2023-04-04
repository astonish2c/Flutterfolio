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
    final ThemeData theme = Theme.of(context);

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
            color: theme.colorScheme.onPrimary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: Image.network(
                coin!.image,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/no-wifi.png',
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              coin!.symbol.toUpperCase(),
              style: theme.textTheme.titleMedium!.copyWith(
                fontSize: 18,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              coin!.name.toCapitalized(),
              style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimary),
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
              style: theme.textTheme.titleMedium!.copyWith(fontSize: 22),
            ),
            SizedBox(height: defaultPadding),
            Expanded(
              child: Builder(builder: (context) {
                context.select((DataProvider dataProvider) => dataProvider.userBalance);

                List<Transaction> localTransactions = coin!.transactions!;

                localTransactions.sort((a, b) {
                  return b.dateTime.compareTo(a.dateTime);
                });
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: localTransactions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: TransactionsItem(coin: coin!, transaction: localTransactions[index]),
                          onTap: () async {
                            await showModalBottomSheet(
                                backgroundColor: theme.colorScheme.primaryContainer,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                                ),
                                context: context,
                                builder: (context) {
                                  return TransactionsBottomSheet(coin: coin!, indexTransaction: index, popPage: popPage);
                                });
                          });
                    });
              }),
            ),
            const SizedBox(height: 16),
            CustomBigBtn(
                text: 'Add Transaction',
                bgColor: Colors.blue[900],
                onTap: () {
                  Navigator.of(context).pushNamed(TabScreen.routeName, arguments: {'coinModel': coin, 'isPushHomePage': false, 'initialPage': 0});
                }),
          ]),
        ),
      ),
    );
  }
}
