import 'package:crypto_exchange_app/screens/add_coins_screen/add_coins_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../custom_widgets/custom_big_btn.dart';
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

    final List<CoinModel> localUserCoins = userCoins;

    localUserCoins.sort((a, b) {
      return calTotalTransactions(b).compareTo(calTotalTransactions(a));
    });

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
                    itemCount: localUserCoins.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: HomeCoinItem(coin: localUserCoins[index]),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TransactionsScreen(coin: localUserCoins[index]),
                            ));
                          });
                    })
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Image.asset('assets/images/sad.png'),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No transactions yet.',
                        style: theme.textTheme.titleMedium!.copyWith(color: Colors.black.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 32),
                      InkWell(
                        onTap: () => Navigator.of(context).pushNamed(AddCoinsScreen.routeName),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                          child: Text(
                            'Add transaction',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
