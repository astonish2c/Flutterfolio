import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    setValues(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoadingUserCoin = context.select((DataProvider dataProvider) => dataProvider.isLoadingUserCoin);
    final bool hasErrorUserCoin = context.select((DataProvider dataProvider) => dataProvider.hasErrorUserCoin);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const HomeAppBar(),
      body: isLoadingUserCoin
          ? const HomeShimmer()
          : hasErrorUserCoin
              ? const MarketCustomError(error: 'Please make sure your internet is connected and try again.')
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
              child: const Icon(Icons.refresh),
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
