import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:crypto_exchange_app/provider/all_coins_provider.dart';
import 'package:crypto_exchange_app/provider/user_coins_provider.dart';
import '../../custom_widgets/custom_alert_dialog.dart';
import '../../custom_widgets/nav_bar.dart';
import '../market_screen/widgets/market_custom_error.dart';
import 'components/home_app_bar.dart';
import 'components/home_balance.dart';
import 'components/home_drawer.dart';
import 'components/home_portfolio.dart';
import 'components/home_shimmer.dart';
import 'helper_methods.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'Holdings-Page';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    setValues(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoadingUserCoin = context.select((UserCoinsProvider userCoinsProvider) => userCoinsProvider.isLoadingUserCoin);
    final bool hasErrorUserCoin = context.select((UserCoinsProvider userCoinsProvider) => userCoinsProvider.hasErrorUserCoin);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
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
      drawer: const Drawer(child: HomeDrawer()),
      floatingActionButton: !hasErrorUserCoin
          ? const Text('')
          : FloatingActionButton(
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.refresh,
                color: theme.colorScheme.onSecondary,
              ),
              onPressed: () async {
                final UserCoinsProvider userCoinsProvider = context.read<UserCoinsProvider>();
                final AllCoinsProvider allCoinsProvider = context.read<AllCoinsProvider>();

                try {
                  setState(() {
                    allCoinsProvider.hasErrorDatabase = false;
                  });
                  await userCoinsProvider.setUserCoin();
                  await allCoinsProvider.setDatabaseCoins();
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
