import 'package:crypto_exchange_app/custom_widgets/custom_image.dart';
import 'package:crypto_exchange_app/provider/allCoins_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../custom_widgets/helper_methods.dart';
import '../../../model/coin_model.dart';
import '../../tab_screen/tab_screen.dart';
import 'market_price_column.dart';

class MarketCoins extends StatelessWidget {
  const MarketCoins({super.key, required this.marketStatus});

  final double marketStatus;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<CoinModel> localCoins = context.read<AllCoinsProvider>().getCoins;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: true,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: localCoins.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.of(context).pushNamed(TabScreen.routeName, arguments: {'coinModel': localCoins[index], 'initialPage': 0});
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16 / 2),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.network(
                                localCoins[index].image,
                                errorBuilder: (context, error, stackTrace) {
                                  return const CustomImage(imagePath: 'assets/images/no-wifi.png');
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(localCoins[index].name.toCapitalized(), style: theme.textTheme.titleMedium),
                                SizedBox(height: 16 / 4),
                                Text(localCoins[index].symbol.toUpperCase(), style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimaryContainer.withOpacity(0.4))),
                              ],
                            ),
                            const Spacer(),
                            MarketPriceColumn(coin: localCoins[index]),
                          ],
                        ),
                      ),
                      const Divider(thickness: 0.2),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
