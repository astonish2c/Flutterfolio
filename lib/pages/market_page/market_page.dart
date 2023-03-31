// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/svg.dart';

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
    super.initState();
    getApiCoins();
  }

  Future<void> getApiCoins() async {
    final readDataProvider = context.read<DataProvider>();

    final bool isDatabaseAvailable = readDataProvider.isDatabaseAvailable;

    if (isDatabaseAvailable || !readDataProvider.firstRun) return;

    try {
      await context.read<DataProvider>().getApiCoins();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoadingMarket = context.select((DataProvider dataProvider) => dataProvider.isLoadingMarket);
    final bool hasErrorMarket = context.select((DataProvider dataProvider) => dataProvider.hasErrorMarket);
    final bool isDbAvailable = context.select((DataProvider dataProvider) => dataProvider.isDatabaseAvailable);

    return Scaffold(
      body: SafeArea(
        child: isLoadingMarket
            ? const ShimmerLoading()
            : hasErrorMarket
                ? isDbAvailable
                    ? const MarketCoins()
                    : CustomError(
                        error: 'Please make sure your internet is connected and try again.',
                      )
                : const MarketCoins(),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 1),
      floatingActionButton: isLoadingMarket
          ? const Text('')
          : FloatingActionButton(
              child: const Icon(Icons.refresh),
              onPressed: () async {
                try {
                  await context.read<DataProvider>().getApiCoins();
                } catch (e) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Ok',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                        title: const Text(
                          'Oh snap!',
                          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        content: SizedBox(
                          width: double.infinity,
                          child: Text(
                            '$e',
                            style: const TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}

class CustomError extends StatelessWidget {
  const CustomError({
    super.key,
    required this.error,
  });
  final String error;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/error.svg',
            width: 140,
            height: 140,
            color: Colors.black.withOpacity(0.4),
          ),
          SizedBox(height: 16),
          Text(
            '''$error''',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black.withOpacity(0.4),
                ),
          ),
        ],
      ),
    );
  }
}

class MarketCoins extends StatelessWidget {
  const MarketCoins({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.blue,
      highlightColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Skelton(width: 90),
                    SizedBox(height: 8),
                    Skelton(height: 36, width: 150, borderCircle: 8),
                  ],
                ),
                const Spacer(),
                const Skelton(height: 50, width: 70, borderCircle: 8),
              ],
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: SkeltonItem(),
            ),
          ],
        ),
      ),
    );
  }
}

class SkeltonItem extends StatelessWidget {
  const SkeltonItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: 12,
      itemBuilder: (context, index) => Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: Row(
              children: [
                const Skelton(
                  height: 50,
                  width: 50,
                  borderCircle: 32,
                ),
                SizedBox(width: defaultPadding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Skelton(width: 60),
                    SizedBox(height: defaultPadding / 4),
                    const Skelton(width: 30),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Skelton(width: 60),
                    SizedBox(height: defaultPadding / 4),
                    const Skelton(width: 60),
                  ],
                ),
                // MarketPriceColumn(coin: coinModel),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16),
    );
  }
}

class Skelton extends StatelessWidget {
  const Skelton({
    super.key,
    this.height,
    this.width,
    this.borderCircle,
  });

  final double? height, width;
  final double? borderCircle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(borderCircle ?? 12)),
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
        physics: const BouncingScrollPhysics(),
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
    final double pMarketChange = context.select((DataProvider dataProvider) => dataProvider.marketCondition);

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
