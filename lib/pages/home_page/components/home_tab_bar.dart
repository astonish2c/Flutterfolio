// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields
import 'package:crypto_exchange_app/utils/icon_btn_zero_padding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/coin_model.dart';
import '../../../provider/theme_provider.dart';
import 'home_items_details.dart';

class HomeTabBar extends StatefulWidget {
  static const routeName = 'Home_Tab_Bar';

  final CoinModel? coinModel;
  final int? indexBuyCoin;
  final bool? pushHomePage;

  const HomeTabBar({super.key, this.coinModel, this.indexBuyCoin, this.pushHomePage});

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> with TickerProviderStateMixin {
  FocusNode _focusNode = FocusNode();
  late TabController _tabController;
  late ThemeProvider _themeProvider;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _themeProvider = Provider.of<ThemeProvider>(context);
    super.didChangeDependencies();
  }

  void unfocusTF(FocusNode focusNode) {
    focusNode.unfocus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  TabBar get _tabBar => TabBar(
        controller: _tabController,
        labelColor: _themeProvider.isDark ? Colors.white : Colors.black,
        tabs: [
          Tab(text: 'Buy'),
          Tab(text: 'Sell'),
          Tab(text: 'Transfer'),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: IconBtnZeroPadding(
            icon: Icons.keyboard_arrow_left,
            size: 25,
            color: _themeProvider.isDark ? Colors.white : Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            children: [
              SizedBox(
                height: 25,
                width: 25,
                child: Image.asset(widget.coinModel!.imageUrl),
              ),
              SizedBox(width: 4),
              Text(
                widget.coinModel!.name,
                style: theme.textTheme.titleMedium!.copyWith(fontSize: 18),
              ),
              SizedBox(width: 4),
              Text(
                widget.coinModel!.shortName.toUpperCase(),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: _tabBar,
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              BuyView(coinModel: widget.coinModel!, indexOfBuyCoin: widget.indexBuyCoin, pushHomePage: widget.pushHomePage),
              Text(''),
              Text(''),
            ],
          ),
        ),
      ),
    );
  }
}
