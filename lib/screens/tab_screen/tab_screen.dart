import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/coin_model.dart';

import '../../provider/utils/helper_methods.dart';
import 'components/tab_screen_buy.dart';
import 'components/tab_screen_appBar.dart';
import 'components/tab_screen_sell.dart';

class TabScreen extends StatefulWidget {
  static const routeName = 'Home_Tab_Bar';

  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late TabController _tabController;

  late CoinModel _coin;
  late int _initialPage;

  late bool? _isPushHomePage;
  late int? _indexTransaction;

  @override
  void didChangeDependencies() {
    final Map<String, dynamic> args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _coin = args['coinModel'] as CoinModel;
    _initialPage = args['initialPage'] as int;
    _isPushHomePage = args['isPushHomePage'];
    _indexTransaction = args['indexTransaction'];

    _tabController = TabController(
      initialIndex: _initialPage,
      length: 2,
      vsync: this,
    );
    super.didChangeDependencies();
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
        appBar: TabScreenAppBar(coinModel: _coin, tabBar: _tabBar),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              BuyTab(
                coin: _coin,
                indexTransaction: _indexTransaction,
                isPushHomePage: _isPushHomePage,
                initialPage: _initialPage,
              ),
              SellTab(
                coin: _coin,
                indexTransaction: _indexTransaction,
                isPushHomePage: _isPushHomePage,
                initialPage: _initialPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
