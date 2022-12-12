// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:crypto_exchange_app/pages/exchange%20page/components/exchange_coin_row.dart';
import 'package:crypto_exchange_app/pages/holdings%20page/holdings_page.dart';
import 'package:flutter/material.dart';
import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../utils/constants.dart';
import '../../holdings page/components/home_bottom_sheet.dart';
import 'coin_list_item.dart';
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        children: [
          //My Portfolio Row
          Row(
            children: [
              Text(
                'My Portfolio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              CustomTextBtn(
                fontSize: 12,
                text: 'Add more',
                onTap: (() async {
                  await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return HomeBottomSheet();
                    },
                  );
                }),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
