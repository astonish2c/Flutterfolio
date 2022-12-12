// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:crypto_exchange_app/pages/holdings%20page/components/coin_detail_screen.dart';
import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:crypto_exchange_app/utils/nav_bar.dart';
import 'package:crypto_exchange_app/utils/scaffold_bg.dart';
import 'package:flutter/material.dart';
import '../../model/coin_model.dart';
import '../../provider/data_provider.dart';
import 'components/grey_small_txt.dart';
import 'components/holdings_balance.dart';
import 'components/holdings_header.dart';
import 'components/holdings_pie_chart.dart';
import 'package:provider/provider.dart';

class HoldingsPage extends StatefulWidget {
  static const routeName = 'Holdings_Page';

  const HoldingsPage({super.key});

  @override
  State<HoldingsPage> createState() => _HoldingsPageState();
}

class _HoldingsPageState extends State<HoldingsPage> {
  late DataProvider dataProvider;
  late List<CoinModel> _userCoins;
  late TextTheme textTheme;

  @override
  void didChangeDependencies() {
    textTheme = Theme.of(context).textTheme;
    dataProvider = Provider.of<DataProvider>(context);
    _userCoins = dataProvider.userCoins;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScaffoldBG(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: EdgeInsets.only(top: defaultPadding, right: defaultPadding, left: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Header or PieChart
                if (_userCoins.isNotEmpty)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      dataProvider.showPieChart ? const HoldingsPieChart() : HoldingsHeader(),
                      Divider(color: Colors.white.withOpacity(0.1), thickness: 1),
                    ],
                  ),
                //Balance Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: defaultPadding / 2),
                      //Title & Search Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Title
                          const Expanded(
                            child: Text(
                              'Balances',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: defaultPadding),
                          //Search Bar
                          Expanded(
                            child: Theme(
                              data: ThemeData(
                                hintColor: Colors.transparent,
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),
                                  hintText: 'Search',
                                  isDense: true,
                                  hintStyle: const TextStyle(
                                    color: Colors.white54,
                                  ),
                                  fillColor: Colors.blue.withOpacity(0.2),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(),
                                    gapPadding: 0,
                                  ),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.only(right: defaultPadding),
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                  ),
                                  suffixIconConstraints: const BoxConstraints(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding / 2),
                      //Hide 0 Balances
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Hide Row
                          Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey, width: 1),
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                              SizedBox(width: defaultPadding / 3),
                              GreySmallText(textTheme: textTheme, text: 'Hide 0 Balances'),
                            ],
                          ),
                          //Sort Row
                          Row(
                            children: [
                              const Text('Sort by'),
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: PopupMenuButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  iconSize: 18,
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  initialValue: 0,
                                  itemBuilder: (context) {
                                    return [
                                      //Sort by value
                                      PopupMenuItem(
                                        child: const Text(
                                          'Value',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _userCoins.sort((a, b) => (b.amount! * b.buyPrice!).compareTo(a.amount! * a.buyPrice!));
                                          });
                                        },
                                      ),
                                      //Sort by name
                                      PopupMenuItem(
                                        child: const Text(
                                          'Name',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _userCoins.sort((a, b) => (a.name).compareTo(b.name));
                                          });
                                        },
                                      ),
                                      //Sort by date
                                      PopupMenuItem(
                                        child: const Text(
                                          'Date',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _userCoins.sort((a, b) => (a.dateTime!).compareTo(b.dateTime!));
                                          });
                                        },
                                      ),
                                    ];
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      //User Coins
                      Expanded(
                        child: _userCoins.isNotEmpty
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: _userCoins.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(CoinDetailScreen.routeName, arguments: {'obj': _userCoins[index]});
                                    },
                                    child: HoldingsBalance(
                                      coinModel: _userCoins[index],
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text(
                                  'No coins added yet!.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: NavBar(currentIndex: 1),
        ),
      ),
    );
  }
}
