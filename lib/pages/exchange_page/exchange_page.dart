// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:crypto_exchange_app/utils/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';
import 'components/exchange_big_btn.dart';
import 'components/exchange_coin_row.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> with TickerProviderStateMixin {
  int _pageIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  void _changePage(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: SafeArea(
            child: Consumer<ThemeProvider>(
              builder: (context, value, child) => Container(
                color: value.isDark ? Colors.black12 : const Color(0xffeff2f5),
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Text('Market', style: textTheme.titleMedium),
                        Text('Limit', style: textTheme.titleMedium),
                      ],
                    ),
                  ],
                ),
              ),
              // child: ,
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ExchangeMarketTab(),
            Text('Limit'),
          ],
        ),
        bottomNavigationBar: const NavBar(currentIndex: 2),
      ),
    );
  }
}

class ExchangeMarketTab extends StatelessWidget {
  const ExchangeMarketTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          //body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                //From Row
                Row(
                  children: [
                    //From
                    Expanded(
                      child: Text('From', style: textTheme.titleMedium),
                    ),
                    //Spot Wallet
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Spot Wallet'),
                        SizedBox(width: 4),
                        InkWell(
                          onTap: () {},
                          child: const Icon(Icons.swap_horiz_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                //coin Row
                const ExchangeCoinRow(
                  iconUrl: "assets/images/bitcoin.png",
                  coinTitle: 'BTC',
                  hintText: '0.0038 - 14000',
                  showTrail: true,
                ),
                SizedBox(height: defaultPadding / 2),
                //Available
                Text('Available: 0.17607917 BTC', style: textTheme.bodyMedium),
                SizedBox(height: 32),
                //Exchange Icon
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {},
                    child: Consumer<ThemeProvider>(
                      builder: (context, value, child) => Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: value.isDark ? Colors.white12 : Colors.black12,
                        ),
                        child: Icon(
                          Icons.swap_vert,
                          color: value.isDark ? Colors.white : Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                //To
                Text('To', style: textTheme.titleMedium),
                SizedBox(height: defaultPadding / 2),
                //coin Row
                const ExchangeCoinRow(
                  iconUrl: "assets/images/ethereum.png",
                  coinTitle: 'ETH',
                  hintText: '0.002 - 14000',
                  showTrail: false,
                ),
                SizedBox(height: defaultPadding * 2),
              ],
            ),
          ),
          //Preview Exchange
          const ExchnageBigBtn(
            text: 'Preview Conversion',
            fontSize: 18,
          ),
        ],
      ),
    );
  }
}
