// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'package:crypto_exchange_app/pages/holdings_page/holdings_page.dart';
import 'package:crypto_exchange_app/pages/home_page/components/home_items_list.dart';
import 'package:flutter/material.dart';
import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../utils/constants.dart';
import '../../exchange_page/components/exchange_coin_row.dart';
import '../utils/home_coin_item.dart';
import 'package:provider/provider.dart';

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
    final List<CoinModel> userCoins = Provider.of<DataProvider>(context).userCoins;
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        children: [
          //My Portfolio Row
          Row(
            children: [
              Text(
                'My Portfolio',
                style: theme.textTheme.titleLarge!.copyWith(fontSize: 24),
              ),
              Spacer(),
              CustomTextBtn(
                fontSize: 12,
                text: 'Add more',
                onTap: () {
                  Navigator.of(context).pushNamed(HomeItemsList.routeName);
                },
              ),
              SizedBox(width: defaultPadding / 2),
              CustomTextBtn(
                fontSize: 12,
                text: 'View details',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => HoldingsPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: defaultPadding / 2),
          //ListView
          Expanded(
            child: userCoins.isNotEmpty
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: userCoins.length,
                    itemBuilder: (context, index) {
                      return CoinListItem(coinModel: userCoins[index]);
                    },
                  )
                : Center(
                    child: Text(
                      'No coins added yet!.',
                      style: theme.textTheme.titleMedium!.copyWith(fontSize: 22),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
