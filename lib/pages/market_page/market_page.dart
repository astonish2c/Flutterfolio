// ignore_for_file: prefer_const_constructors

import 'package:crypto_exchange_app/pages/home_page/utils/home_coin_item.dart';
import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:crypto_exchange_app/utils/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/data_provider.dart';
import 'components/market_filter_btn.dart';

class MarketPage extends StatefulWidget {
  static const routeName = 'Market_Page';

  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  int isSelected = 0;

  void toggleSelected(int currentIndex) {
    setState(() {
      isSelected = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final deviceWidth = MediaQuery.of(context).size.width;
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: defaultPadding * 2),
          child: Column(
            children: [
              //Market Condition Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Past 24 hours
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'in the past 24 hours',
                        style: textTheme.bodyMedium,
                      ),
                      Text(
                        'Market is up',
                        style: textTheme.titleMedium!.copyWith(fontSize: 26),
                      ),
                    ],
                  ),
                  //Market status
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+9.17%',
                      style: textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: defaultPadding),
              //Category Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MarketFilterBtn(
                    isSelected: isSelected == 0 ? true : false,
                    text: 'All',
                    onTap: () => toggleSelected(0),
                  ),
                  SizedBox(width: deviceWidth > 380 ? defaultPadding * 2 : defaultPadding),
                  MarketFilterBtn(
                    isSelected: isSelected == 1 ? true : false,
                    text: '24h',
                    onTap: () => toggleSelected(1),
                  ),
                  SizedBox(width: deviceWidth > 380 ? defaultPadding * 2 : defaultPadding),
                  MarketFilterBtn(
                    isSelected: isSelected == 2 ? true : false,
                    text: 'Top',
                    onTap: () => toggleSelected(2),
                  ),
                ],
              ),
              SizedBox(height: defaultPadding),
              //Crypto list
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: dataProvider.allCoins.length,
                  itemBuilder: (context, index) {
                    return CoinListItem(coinModel: dataProvider.allCoins[index]);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 3),
    );
  }
}
