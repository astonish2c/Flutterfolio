import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto_exchange_app/custom_widgets/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_alert_dialog.dart';
import '../../custom_widgets/nav_bar.dart';
import '../../provider/data_provider.dart';
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
  late double marketStatus;
  late StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    getApiCoins();
    _subscription = context.read<DataProvider>().listenConnectivity(context);
    marketStatus = context.read<DataProvider>().marketStatus;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
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

    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
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
                        style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimary),
                      ),
                      Text(
                        marketStatus < 0 ? 'Market is down' : 'Market is up',
                        style: theme.textTheme.titleMedium!.copyWith(fontSize: 26, color: theme.colorScheme.onPrimary),
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
        child: isLoadingMarket
            ? const MarketShimmer()
            : hasErrorMarket
                ? isDbAvailable
                    ? MarketCoins(marketStatus: marketStatus)
                    : const MarketCustomError(
                        error: 'Please make sure your internet is connected and try again.',
                        pngPath: 'assets/images/no-wifi.png',
                      )
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
                  await context.read<DataProvider>().getApiCoins();
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
