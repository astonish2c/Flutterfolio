import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
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

    return Scaffold(
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
              child: const Icon(Icons.refresh),
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
