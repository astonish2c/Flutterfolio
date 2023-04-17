import 'package:Flutterfolio/screens/market_screen/models/market_error_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/allCoins_provider.dart';

class MarketError extends StatelessWidget {
  const MarketError({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AllCoinsProvider provider = Provider.of<AllCoinsProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MarketErrorModel(
          error: error,
          pngPath: 'assets/images/sad.png',
        ),
        SizedBox(height: 24),
        TextButton(
          child: Text(
            'Try again',
            style: theme.textTheme.titleMedium,
          ),
          style: TextButton.styleFrom(
            side: BorderSide(width: 1, color: theme.colorScheme.onBackground),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          onPressed: () {
            provider.setIsFirstRun(true);
            provider.setIsLoadingMarket(true);
          },
        ),
      ],
    );
  }
}
