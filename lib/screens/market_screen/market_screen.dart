import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_alertDialog.dart';
import '../../custom_widgets/custom_navBar.dart';
import '../home_screen/widgets/utils.dart';
import '/custom_widgets/helper_methods.dart';
import '../../provider/allCoins_provider.dart';
import '../../provider/userCoins_provider.dart';
import 'components/market_coins.dart';
import 'components/market_shimmer.dart';
import 'components/market_status.dart';
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

    if (isDatabaseAvailable || !readAllCoinsProvider.isFirstRun) return;

    try {
      await readAllCoinsProvider.getApiCoins();
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool isLoadingMarket = context.select((AllCoinsProvider allCoinsProvider) => allCoinsProvider.isLoadingMarket);
    final bool hasErrorMarket = context.select((AllCoinsProvider allCoinsProvider) => allCoinsProvider.hasErrorMarket);
    final bool isDbAvailable = context.select((AllCoinsProvider allCoinsProvider) => allCoinsProvider.isDatabaseAvailable);
    final bool hasErrorUserCoin = context.select((UserCoinsProvider userCoinsProvider) => userCoinsProvider.hasErrorUserCoin);

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: hasErrorMarket || isLoadingMarket ? const Text('') : MarketStatusSection(marketStatus: marketStatus),
      // ),
      body: SafeArea(
        child: hasErrorUserCoin
            ? isDbAvailable
                ? const MarketCoins()
                : const MarketCustomError(
                    error: 'Please make sure your internet is connected and try again.',
                    pngPath: 'assets/images/no-wifi.png',
                  )
            : isLoadingMarket
                ? const MarketShimmer()
                : const MarketCoins(),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
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
