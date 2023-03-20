import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/data_provider.dart';
import '../../utils/nav_bar.dart';
import 'components/home_app_bar.dart';
import 'components/balance_section.dart';
import 'components/portfolio_section.dart';

class HoldingsPage extends StatefulWidget {
  const HoldingsPage({super.key});

  @override
  State<HoldingsPage> createState() => _HoldingsPageState();
}

class _HoldingsPageState extends State<HoldingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState!.showBottomSheet(
      (context) => SnackBar(content: Text(value)),
    );
  }

  Future<void> setPreValues() async {
    DataProvider dataProvider = context.read<DataProvider>();
    if (dataProvider.firstRun) {
      await dataProvider.fetchAllCoinsFirebase();
      await dataProvider.setAllCoins();
      await dataProvider.periodicSetAllCoin();
      dataProvider.setUserCoin();
    }
  }

  @override
  void initState() {
    super.initState();
    setPreValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: const HomeAppBar(),
      body: Column(
        children: const [
          Balance(),
          SizedBox(height: 12),
          Expanded(
            child: Portfolio(),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(currentIndex: 0),
    );
  }
}
