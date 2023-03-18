import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utils/constants.dart';
import '/utils/nav_bar.dart';
import '../../provider/data_provider.dart';
import '/pages/market_page/components/market_coin_row.dart';

class MarketPage extends StatefulWidget {
  static const routeName = 'Market_Page';

  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  int isSelected = 0;

  void toggleSelected(int currentIndex) {
    setState(() {
      isSelected = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //Market Condition Row
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
                              dataProvider.marketCapPercentage < 0 ? 'Market is down' : 'Market is up',
                              style: textTheme.titleMedium!.copyWith(fontSize: 26),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: dataProvider.marketCapPercentage < 0 ? Colors.red : Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            dataProvider.marketCapPercentage < 0 ? '${convertPerToNum(dataProvider.marketCapPercentage.toString())}%' : '+${convertPerToNum(dataProvider.marketCapPercentage.toString())}%',
                            style: textTheme.bodyMedium!.copyWith(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultPadding),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: dataProvider.allCoins.length,
                        itemBuilder: (context, index) {
                          return MarketCoinRow(coinModel: dataProvider.allCoins[index]);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 1),
    );
  }
}
