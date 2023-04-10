import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_alert_dialog.dart';
import '../../custom_widgets/nav_bar.dart';
import '/custom_widgets/helper_methods.dart';
import '/provider/all_coins_provider.dart';
import '/provider/user_coins_provider.dart';
import 'components/market_coins.dart';
import 'components/market_shimmer.dart';
import 'widgets/market_custom_error.dart';

class MarketScreen extends StatefulWidget {
  static const routeName = 'Market_Page';

  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  void initState() {
    super.initState();
    getApiCoins();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getApiCoins() async {
    final AllCoinsProvider readAllCoinsProvider = context.read<AllCoinsProvider>();

    final bool isDatabaseAvailable = readAllCoinsProvider.isDatabaseAvailable;

    if (isDatabaseAvailable || !readAllCoinsProvider.firstRun) return;

    try {
      await readAllCoinsProvider.getApiCoins();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool isLoadingMarket = context.select((AllCoinsProvider allCoinsProvider) => allCoinsProvider.isLoadingMarket);
    final bool hasErrorMarket = context.select((AllCoinsProvider allCoinsProvider) => allCoinsProvider.hasErrorMarket);
    final bool isDbAvailable = context.select((AllCoinsProvider allCoinsProvider) => allCoinsProvider.isDatabaseAvailable);
    final double marketStatus = context.select((AllCoinsProvider allCoinsProvider) => allCoinsProvider.marketStatus);
    final bool hasErrorUserCoin = context.select((UserCoinsProvider userCoinsProvider) => userCoinsProvider.hasErrorUserCoin);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: hasErrorMarket || isLoadingMarket
            ? const Text('')
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'in the past 24 hours',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        marketStatus < 0 ? 'Market is down' : 'Market is up',
                        style: theme.textTheme.titleMedium!.copyWith(fontSize: 26),
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
                      style: theme.textTheme.bodyMedium!.copyWith(color: Colors.black),
                    ),
                  ),
                ],
              ),
      ),
      body: SafeArea(
        child: hasErrorUserCoin
            ? isDbAvailable
                ? MarketCoins(marketStatus: marketStatus)
                : const MarketCustomError(
                    error: 'Please make sure your internet is connected and try again.',
                    pngPath: 'assets/images/no-wifi.png',
                  )
            : isLoadingMarket
                ? const MarketShimmer()
                : MarketCoins(marketStatus: marketStatus),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 1),
      floatingActionButton: isLoadingMarket
          ? const Text('')
          : FloatingActionButton(
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.refresh,
                color: theme.colorScheme.onSecondary,
              ),
              onPressed: () async {
                try {
                  if (hasErrorUserCoin) {
                    await context.read<UserCoinsProvider>().setUserCoin();
                  }
                  if (mounted) {
                    await context.read<AllCoinsProvider>().getApiCoins();
                  }
                } catch (e) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(error: e.toString());
                    },
                  );
                }
              },
            ),
    );
  }
}
