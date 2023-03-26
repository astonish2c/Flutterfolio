import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/coin_model.dart';
import '/utils/constants.dart';
import '/utils/nav_bar.dart';
import '../../provider/data_provider.dart';
import '/pages/market_page/components/market_coin_row.dart';

class MarketPage extends StatelessWidget {
  static const routeName = 'Market_Page';

  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('MarketPage build called');

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
                    const MarketChangeSection(),
                    SizedBox(height: defaultPadding),
                    FutureBuilder(
                      future: context.read<DataProvider>().getApiCoins(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(child: CircularProgressIndicator());
                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              List<CoinModel> coins = [];
                              for (var coinItem in snapshot.data!) {
                                CoinModel coin = CoinModel.fromJson(coinItem as Map<String, dynamic>);
                                coins.add(coin);
                              }
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: coins.length,
                                  itemBuilder: (context, index) {
                                    return MarketCoinRow(coinModel: coins[index]);
                                  },
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            } else {
                              return const Text('AllCoins is empty');
                            }
                          case ConnectionState.none:
                            return const Text('None state');
                          case ConnectionState.active:
                            return const Text('active state');
                        }
                      },
                    ),
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

class MarketChangeSection extends StatelessWidget {
  const MarketChangeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder(
      future: context.read<DataProvider>().setMcPercentage(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasData) {
              return Row(
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
                        snapshot.data! < 0 ? 'Market is down' : 'Market is up',
                        style: textTheme.titleMedium!.copyWith(fontSize: 26),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: snapshot.data! < 0 ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      snapshot.data! < 0 ? '${convertPerToNum(snapshot.data!.toString())}%' : '+${convertPerToNum(snapshot.data!.toString())}%',
                      style: textTheme.bodyMedium!.copyWith(color: Colors.black),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const Text('No data');
            }
          case ConnectionState.none:
            return const Text('Calling none state');
          case ConnectionState.active:
            return const Text('Calling active state');
        }
      },
    );
  }
}
