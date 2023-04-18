import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Auth/widgets/utils.dart';
import '../../custom_widgets/custom_error.dart';
import '../../provider/allCoins_provider.dart';
import 'components/market_coins.dart';
import 'components/market_shimmer.dart';

class MarketScreen extends StatefulWidget {
  static const routeName = 'Market_Page';

  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AllCoinsProvider provider = context.read<AllCoinsProvider>();

    final bool isFirstRun = context.select((AllCoinsProvider allCoinsProvider) => allCoinsProvider.getIsFirstRun);
    final bool isLoading = context.select((AllCoinsProvider allCoinsProvider) => allCoinsProvider.getIsLoadingMarket);

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: isFirstRun ? provider.getApiData() : Future.sync(() => provider.getCoins),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && isFirstRun) {
              return MarketShimmer();
            }
            if (snapshot.hasError) {
              if (provider.getCoins.isEmpty)
                return CustomError(
                  imagePath: 'assets/images/no-wifi.png',
                  error: snapshot.error.toString(),
                  onPressed: () {
                    provider.setIsFirstRun(true);
                    provider.setIsLoadingMarket(true);
                    setState(() {});
                  },
                  buttonTitle: 'Try again',
                );
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) => Utils.showSnackBar(snapshot.error.toString()));
              return MarketCoins();
            }
            return const MarketCoins();
          },
        ),
      ),
      floatingActionButton: isLoading
          ? const SizedBox()
          : provider.getCoins.isEmpty
              ? const SizedBox()
              : FloatingActionButton(
                  backgroundColor: theme.colorScheme.primary,
                  child: Icon(Icons.refresh, color: theme.colorScheme.onSecondary),
                  onPressed: () {
                    provider.setIsFirstRun(true);
                    provider.setIsLoadingMarket(true);
                  },
                ),
    );
  }
}
