// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/coin_model.dart';
import '../../provider/theme_provider.dart';
import '../../utils/constants.dart';
import '../../utils/nav_bar.dart';
import '../holdings_page/components/holdings_item_transactions.dart';
import '../../provider/data_provider.dart';
import 'components/holdings_Item_list.dart';
import 'components/holdings_header_section.dart';

class HoldingsPage extends StatefulWidget {
  static const routeName = 'Holdings_Page';

  const HoldingsPage({super.key});

  @override
  State<HoldingsPage> createState() => _HoldingsPageState();
}

class _HoldingsPageState extends State<HoldingsPage> {
  final FocusNode _searchFocusNode = FocusNode();

  late List<CoinModel> userCoins;
  late DataProvider dataProvider;

  @override
  void didChangeDependencies() {
    dataProvider = Provider.of<DataProvider>(context); //for initializing our local list & later for accessing our provider functions
    userCoins = dataProvider.userCoins; //a local copy of userCoins for sorting
    // print('DidChangeDependencies of HoldingsPage is called');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    // print('Holdings page build is run');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: defaultPadding, right: defaultPadding, left: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Header or PieChart
                Consumer<DataProvider>(
                  builder: (context, value, child) => value.userCoins.isNotEmpty
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // _dataProvider.showPieChart ? const HoldingsPieChart() : HoldingsHeader(),
                            HoldingsHeaderSection(),
                            Consumer<ThemeProvider>(
                              builder: (context, value, child) => Divider(
                                color: value.isDark ? Colors.white54 : Colors.black54,
                              ),
                              // child: ,
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
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
                          Expanded(
                            child: Text(
                              'Balances',
                              style: textTheme.titleLarge!.copyWith(fontSize: 28),
                            ),
                          ),
                          SizedBox(width: defaultPadding),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: Consumer<ThemeProvider>(
                                builder: (context, value, child) => TextField(
                                  focusNode: _searchFocusNode,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 16, right: 8),
                                    hintText: 'Search',
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.transparent),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: value.isDark ? Colors.white54 : Colors.black54)),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Consumer<ThemeProvider>(
                                        builder: (context, value, child) => Icon(
                                          Icons.search,
                                          color: value.isDark ? Colors.white54 : Colors.black54,
                                        ),
                                      ),
                                    ),
                                    suffixIconConstraints: const BoxConstraints(),
                                  ),
                                ),
                                // child: ,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding / 2),
                      //Hide 0 Balances & Sort by
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Consumer<ThemeProvider>(
                                  builder: (context, value, child) => Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: value.isDark ? Colors.white : Colors.black,
                                        width: 1,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  // child: ,
                                ),
                              ),
                              SizedBox(width: defaultPadding / 3),
                              Text('Hide zero balances', style: textTheme.bodyMedium)
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Sort by',
                                style: textTheme.bodyMedium,
                              ),
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: PopupMenuButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  iconSize: 18,
                                  icon: const Icon(
                                    Icons.more_vert,
                                    // color: Colors.white,
                                  ),
                                  initialValue: 0,
                                  itemBuilder: (context) {
                                    return [
                                      //Sort by value
                                      PopupMenuItem(
                                        child: Text(
                                          'Value',
                                          style: textTheme.bodyMedium,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            userCoins.sort(
                                              (a, b) => dataProvider.calTotalValue(b).compareTo(dataProvider.calTotalValue(a)),
                                            );
                                          });
                                        },
                                      ),
                                      //Sort by name
                                      PopupMenuItem(
                                        child: Text(
                                          'Name',
                                          style: textTheme.bodyMedium,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            userCoins.sort((a, b) => (a.name).compareTo(b.name));
                                          });
                                        },
                                      ),
                                      //Sort by date
                                      PopupMenuItem(
                                        child: Text(
                                          'Amount',
                                          style: textTheme.bodyMedium,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            userCoins.sort(
                                              (a, b) => double.parse(dataProvider.calTotalAmount(b))
                                                  .compareTo(double.parse(dataProvider.calTotalAmount(a))),
                                            );
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
                      //Coin type & quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Coin Type',
                            style: textTheme.titleSmall,
                          ),
                          Text(
                            'Total Quantity',
                            style: textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding),
                      //User Coins
                      Expanded(
                        child: userCoins.isNotEmpty
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: userCoins.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (context) => HoldingsItemTransactions(coinModel: userCoins[index])));
                                    },
                                    child: HoldingsItemList(coinModel: userCoins[index]),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  'No coins added yet!.',
                                  style: textTheme.titleMedium!.copyWith(fontSize: 22),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavBar(currentIndex: 1),
      ),
    );
  }
}
