import 'package:crypto_exchange_app/custom_widgets/custom_image.dart';
import 'package:crypto_exchange_app/provider/allCoins_provider.dart';
import 'package:crypto_exchange_app/provider/userCoins_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/tab_screen/tab_screen.dart';
import '../../custom_widgets/custom_iconButton.dart';
import 'components/transactions_bottom_sheet.dart';
import '../../custom_widgets/helper_methods.dart';
import '../../model/coin_model.dart';

import '../../provider/theme_provider.dart';
import '../../custom_widgets/custom_bigButton.dart';
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
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              coin!.image,
              height: 25,
              width: 25,
              errorBuilder: (context, error, stackTrace) => const CustomImage(
                imagePath: 'assets/images/no-wifi.png',
                size: 25,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              coin!.symbol.toUpperCase(),
              style: theme.textTheme.titleMedium!.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              coin!.name.toCapitalized(),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Transactions',
              style: theme.textTheme.titleMedium!.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(builder: (context) {
                context.select((UserCoinsProvider userCoinsProvider) => userCoinsProvider.userBalance);

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
            CustomBigButton(
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
