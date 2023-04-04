import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../provider/theme_provider.dart';
import '/custom_widgets/custom_alert_dialog.dart';
import '../../provider/data_provider.dart';
import '../../custom_widgets/nav_bar.dart';
import '../market_screen/widgets/market_custom_error.dart';
import 'components/home_app_bar.dart';
import 'components/home_balance.dart';
import 'components/home_portfolio.dart';
import 'components/home_shimmer.dart';
import 'helper_methods.dart';

class HoldingsPage extends StatefulWidget {
  const HoldingsPage({super.key});

  @override
  State<HoldingsPage> createState() => _HoldingsPageState();
}

class _HoldingsPageState extends State<HoldingsPage> {
  late StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    _subscription = context.read<DataProvider>().listenConnectivity(context);
    setValues(context: context);

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoadingUserCoin = context.select((DataProvider dataProvider) => dataProvider.isLoadingUserCoin);
    final bool hasErrorUserCoin = context.select((DataProvider dataProvider) => dataProvider.hasErrorUserCoin);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: HomeAppBar(hasErrorUserCoin: hasErrorUserCoin),
      body: isLoadingUserCoin
          ? const HomeShimmer()
          : hasErrorUserCoin
              ? const MarketCustomError(
                  error: 'Please make sure your internet is connected and try again.',
                  pngPath: 'assets/images/no-wifi.png',
                )
              : Column(
                  children: const [
                    HomeBalance(),
                    SizedBox(height: 12),
                    Expanded(
                      child: HomePortfolio(),
                    ),
                  ],
                ),
      bottomNavigationBar: const NavBar(currentIndex: 0),
      floatingActionButton: !hasErrorUserCoin
          ? const Text('')
          : FloatingActionButton(
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.refresh,
                color: theme.colorScheme.onSecondary,
              ),
              onPressed: () async {
                final dataProvider = context.read<DataProvider>();
                try {
                  setState(() {
                    dataProvider.hasErrorDatabase = false;
                  });
                  await dataProvider.setUserCoin();
                  await dataProvider.setDatabaseCoins();
                } catch (e) {
                  await showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(error: e.toString()),
                  );
                }
              },
            ),
    );
  }
}