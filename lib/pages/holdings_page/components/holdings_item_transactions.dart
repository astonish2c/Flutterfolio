// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:crypto_exchange_app/pages/exchange_page/components/exchange_big_btn.dart';
import 'package:crypto_exchange_app/pages/home_page/components/home_items_details.dart';
import 'package:crypto_exchange_app/pages/home_page/components/home_tab_bar.dart';
import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:crypto_exchange_app/utils/icon_btn_zero_padding.dart';
import 'package:crypto_exchange_app/utils/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../provider/theme_provider.dart';
import '../utils/coin_details_screen_list_item.dart';
import '../utils/transaction_details_bottom_sheet.dart';

class HoldingsItemTransactions extends StatelessWidget {
  final CoinModel? coinModel;
  static const routeName = 'CoinDetailScreen';

  const HoldingsItemTransactions({
    super.key,
    this.coinModel,
  });

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    void popPage() {
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Consumer<ThemeProvider>(
          builder: (context, value, child) => IconBtnZeroPadding(
            icon: Icons.arrow_back_ios,
            color: value.isDark ? Colors.white : Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          coinModel!.name.toUpperCase(),
          style: textTheme.titleMedium,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              Text(
                'Transactions',
                style: textTheme.titleMedium,
              ),
              SizedBox(height: defaultPadding),
              //Type & Quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Type', style: textTheme.titleMedium),
                  Text('Quantity', style: textTheme.titleMedium),
                ],
              ),
              SizedBox(height: defaultPadding),
              //Item Details
              Expanded(
                child: ListView.builder(
                  itemCount: coinModel!.transactions!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                          ),
                          context: context,
                          builder: (context) {
                            return TransactionDetailsBottomSheet(coinModel: coinModel!, index: index, dataProvider: dataProvider, popPage: popPage);
                          },
                        );
                      },
                      child: CoinDetailScreenListItem(coinModel: coinModel!, buyCoin: coinModel!.transactions![index]),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              ExchnageBigBtn(
                text: 'Add Transaction',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeTabBar(coinModel: coinModel, pushHomePage: false)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
