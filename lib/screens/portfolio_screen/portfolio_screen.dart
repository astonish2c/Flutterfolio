import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_noInternet.dart';
import '../../provider/allCoins_provider.dart';
import '../../provider/userCoins_provider.dart';
import '../../custom_widgets/custom_alertDialog.dart';
import 'components/portfolio_app_bar.dart';
import 'components/portfolio_balance.dart';
import 'components/portfolio_drawer.dart';
import 'components/portfolio_coins_section.dart';
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
    // call after first frame to avoid using context synchronously in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setValues(context: context);
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool isLoading = context.select((UserCoinsProvider provider) => provider.isLoadingUserCoin);
    final bool hasError = context.select((UserCoinsProvider provider) => provider.hasErrorUserCoin);

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: PortfolioAppBar(),
      body: SafeArea(
        child: isLoading
            ? const PortfolioShimmer()
            : hasError
            ? const CustomNoInternet(error: 'Please make sure your internet is connected and try again.')
            : Column(
                children: const [
                  PortfolioBalance(),
                  SizedBox(height: 12),
                  Expanded(child: PortfolioCoinsSection()),
                ],
              ),
      ),
      drawer: PortfolioDrawer(scaffoldKey: _scaffoldKey),
      floatingActionButton: !hasError
          ? const Text('')
          : FloatingActionButton(
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.refresh, color: theme.colorScheme.onSecondary),
              onPressed: () async {
                final UserCoinsProvider userCoinsProvider = context.read<UserCoinsProvider>();
                final AllCoinsProvider allCoinsProvider = context.read<AllCoinsProvider>();

                try {
                  await Future.sync(() => userCoinsProvider.listenUserCoins());
                  await allCoinsProvider.setDatabaseData();
                } catch (e) {
                  if (!context.mounted) return;
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
