import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/allCoins_provider.dart';
import '../../provider/userCoins_provider.dart';
import '../../custom_widgets/custom_alertDialog.dart';
import '../market_screen/widgets/market_custom_error.dart';
import 'components/portfolio_appBar.dart';
import 'components/portfolio_balance.dart';
import 'components/portfolio_drawer.dart';
import 'components/portfolio_coinsSection.dart';
import 'components/portfolio_shimmer.dart';
import 'widgets/helper_methods.dart';

class PortfolioScreen extends StatefulWidget {
  static const routeName = 'Portfolio_Screen';

  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  void initState() {
    super.initState();
    setValues(context: context);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print('Portfolio Build');
    final ThemeData theme = Theme.of(context);
    final UserCoinsProvider provider = Provider.of<UserCoinsProvider>(context);

    final bool isLoadingUserCoin = provider.isLoadingUserCoin;
    final bool hasErrorUserCoin = provider.hasErrorUserCoin;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: PortfolioAppBar(hasErrorUserCoin: hasErrorUserCoin),
      body: SafeArea(
        child: isLoadingUserCoin
            ? const PortfolioShimmer()
            : hasErrorUserCoin
                ? const MarketCustomError(
                    error: 'Please make sure your internet is connected and try again.',
                    pngPath: 'assets/images/no-wifi.png',
                  )
                : Column(
                    children: const [
                      PortfolioBalance(),
                      SizedBox(height: 12),
                      Expanded(
                        child: PortfolioCoinsSection(),
                      ),
                    ],
                  ),
      ),
      drawer: PortfolioDrawer(scaffoldKey: _scaffoldKey),
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
