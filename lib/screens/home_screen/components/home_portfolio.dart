import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../custom_widgets/helper_methods.dart';
import '../../market_screen/widgets/market_custom_error.dart';
import '../../transactions_screen/transactions_screen.dart';
import 'home_coin_item.dart';

class HomePortfolio extends StatefulWidget {
  const HomePortfolio({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePortfolio> createState() => _HomePortfolioState();
}

class _HomePortfolioState extends State<HomePortfolio> {
  late TextEditingController _amountController;
  late TextEditingController _priceController;

  @override
  void initState() {
    _amountController = TextEditingController();
    _priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<CoinModel> userCoins = context.watch<DataProvider>().userCoins;
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'My Portfolio',
                style: theme.textTheme.titleLarge!.copyWith(fontSize: 24),
              ),
            ],
          ),
          SizedBox(height: defaultPadding / 2),
          Expanded(
            child: userCoins.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: userCoins.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: HomeCoinItem(coin: userCoins[index]),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TransactionsScreen(coin: userCoins[index]),
                            ));
                          });
                    })
                : const MarketCustomError(error: 'No coins added yet.'),
          ),
        ],
      ),
    );
  }
}
