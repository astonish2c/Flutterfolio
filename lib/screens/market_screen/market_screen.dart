import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_alertDialog.dart';
import '../../custom_widgets/custom_navBar.dart';
import '../../Auth/widgets/utils.dart';
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
    final AllCoinsProvider allCoinsProvider = Provider.of<AllCoinsProvider>(context);
    final UserCoinsProvider userCoinsProvider = Provider.of<UserCoinsProvider>(context);

    final bool isLoadingMarket = allCoinsProvider.isLoadingMarket;
    final bool isDbAvailable = allCoinsProvider.isDatabaseAvailable;
    final bool hasErrorUserCoin = userCoinsProvider.hasErrorUserCoin;

    return Scaffold(
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
