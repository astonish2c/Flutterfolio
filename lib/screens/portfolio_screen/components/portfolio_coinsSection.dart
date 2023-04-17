import 'package:Flutterfolio/custom_widgets/custom_roundButton.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../custom_widgets/custom_image.dart';
import '../../../provider/userCoins_provider.dart';
import '../../addCoins_screen/addCoins_screen.dart';
import '../../../models/coin_model.dart';
import '../../../custom_widgets/helper_methods.dart';
import '../../transactions_screen/transactions_screen.dart';
import '../widgets/portfolio_coinSkeleton.dart';

class PortfolioCoinsSection extends StatefulWidget {
  const PortfolioCoinsSection({
    Key? key,
  }) : super(key: key);

  @override
  State<PortfolioCoinsSection> createState() => _PortfolioCoinsSectionState();
}

class _PortfolioCoinsSectionState extends State<PortfolioCoinsSection> {
  late TextEditingController _amountController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<CoinModel> userCoins = context.watch<UserCoinsProvider>().userCoins;
    final ThemeData theme = Theme.of(context);

    final List<CoinModel> localUserCoins = userCoins;

    localUserCoins.sort((a, b) {
      return calTotalCost(b).compareTo(calTotalCost(a));
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'My Portfolio',
                style: theme.textTheme.titleMedium!.copyWith(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 16 / 2),
          Expanded(
            child: userCoins.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: localUserCoins.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: PortfolioCoinSkeleton(coin: localUserCoins[index]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionsScreen(coin: localUserCoins[index]),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomImage(imagePath: 'assets/images/sad.png'),
                      const SizedBox(height: 24),
                      Text(
                        'No transactions yet.',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 32),
                      CustomRoundButton(
                        title: 'Add transaction',
                        onPressed: () => Navigator.of(context).pushNamed(AddCoinsScreen.routeName),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
