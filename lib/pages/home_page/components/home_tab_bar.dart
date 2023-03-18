import 'package:crypto_exchange_app/pages/home_page/components/sell_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:crypto_exchange_app/pages/home_page/components/item_app_bar.dart';
import '../../../model/coin_model.dart';
import '../../../provider/theme_provider.dart';
import 'buy_tab.dart';

class HomeTabBar extends StatefulWidget {
  static const routeName = 'Home_Tab_Bar';

  final int? initialPage;
  final CoinModel? coinModel;
  final int? indexTransaction;
  final bool? pushHomePage;

  const HomeTabBar({super.key, this.coinModel, this.indexTransaction, this.pushHomePage, this.initialPage});

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: widget.initialPage!,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void unfocusTF(FocusNode focusNode) {
    focusNode.unfocus();
  }

  TabBar get _tabBar => TabBar(
        controller: _tabController,
        labelColor: context.watch<ThemeProvider>().isDark ? Colors.white : Colors.black,
        tabs: const [
          Tab(text: 'Buy'),
          Tab(text: 'Sell'),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: ItemAppBar(coinModel: widget.coinModel!, tabBar: _tabBar),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              BuyTab(coinModel: widget.coinModel!, indexTransaction: widget.indexTransaction, pushHomePage: widget.pushHomePage, initialPage: widget.initialPage!),
              SellTab(coinModel: widget.coinModel!, indexTransaction: widget.indexTransaction, pushHomePage: widget.pushHomePage, initialPage: widget.initialPage!),
            ],
          ),
        ),
      ),
    );
  }
}
