import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/custom_widgets/custom_image.dart';
import '/provider/allCoins_provider.dart';
import '../../../custom_widgets/helper_methods.dart';
import '../../../models/coin_model.dart';
import '../../tab_screen/tab_screen.dart';
import 'market_price_column.dart';
import 'market_status.dart';

class MarketCoins extends StatelessWidget {
  const MarketCoins({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<CoinModel> localCoins = context.read<AllCoinsProvider>().getCoins;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          toolbarHeight: 92,
          leadingWidth: MediaQuery.of(context).size.width,
          leading: const Padding(
            padding: EdgeInsets.all(16),
            child: MarketStatusSection(),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: localCoins.length,
            (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).pushNamed(TabScreen.routeName, arguments: {'coinModel': localCoins[index], 'initialPage': 0});
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(localCoins[index].name.toCapitalized(), style: theme.textTheme.titleMedium),
                              const SizedBox(height: 16 / 4),
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
      ],
    );
  }
}
