// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/coin_model.dart';
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
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkDbStatus();
    });

    super.initState();
  }

  Future<void> checkDbStatus() async {
    final bool is_Database_Available = context.read<DataProvider>().is_DataBase_Available;

    if (is_Database_Available) return;

    try {
      await context.read<DataProvider>().getApiCoins();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.select((DataProvider dataProvider) => dataProvider.isLoading);
    final bool hasError = context.select((DataProvider dataProvider) => dataProvider.hasError);

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Oh snap! you got Corona!'))
              : SafeArea(
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
                              const CoinsSection(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: const NavBar(currentIndex: 1),
      floatingActionButton: isLoading
          ? const Text('')
          : FloatingActionButton(
              child: const Icon(Icons.refresh),
              onPressed: () async {
                try {
                  await context.read<DataProvider>().getApiCoins();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      content: Container(
                        height: 90,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Oh snap!',
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Text('$e', style: const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 14, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}

class CoinsSection extends StatelessWidget {
  const CoinsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CoinModel> coins = context.read<DataProvider>().getCoins;

    return Expanded(
      child: ListView.builder(
        itemCount: coins.length,
        itemBuilder: (context, index) {
          return MarketCoinRow(coinModel: coins[index]);
        },
      ),
    );
  }
}

class MarketChangeSection extends StatelessWidget {
  const MarketChangeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double pMarketChange = context.select((DataProvider dataProvider) => dataProvider.pMarketChange);

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
              pMarketChange < 0 ? 'Market is down' : 'Market is up',
              style: textTheme.titleMedium!.copyWith(fontSize: 26),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: pMarketChange < 0 ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            pMarketChange < 0 ? '${convertPerToNum(pMarketChange.toString())}%' : '+${convertPerToNum(pMarketChange.toString())}%',
            style: textTheme.bodyMedium!.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
