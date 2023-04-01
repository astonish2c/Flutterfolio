import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../custom_widgets/helper_methods.dart';
import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import 'market_price_column.dart';

class MarketCoins extends StatelessWidget {
  const MarketCoins({super.key, required this.marketStatus});

  final double marketStatus;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final List<CoinModel> coins = context.read<DataProvider>().getCoins;

    return Padding(
      padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'in the past 24 hours',
                          style: textTheme.bodyMedium,
                        ),
                        Text(
                          marketStatus < 0 ? 'Market is down' : 'Market is up',
                          style: textTheme.titleMedium!.copyWith(fontSize: 26),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: marketStatus < 0 ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        marketStatus < 0 ? '${convertPerToNum(marketStatus.toString())}%' : '+${convertPerToNum(marketStatus.toString())}%',
                        style: textTheme.bodyMedium!.copyWith(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: coins.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Image.network(coins[index].image),
                                ),
                                SizedBox(width: defaultPadding),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(coins[index].name.toCapitalized(), style: textTheme.titleMedium),
                                    SizedBox(height: defaultPadding / 4),
                                    Text(coins[index].symbol.toUpperCase(), style: textTheme.bodyMedium),
                                  ],
                                ),
                                const Spacer(),
                                MarketPriceColumn(coin: coins[index]),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
