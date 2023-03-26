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
  Future<void> setValues() async {
    DataProvider dataProvider = context.read<DataProvider>();

    if (!dataProvider.firstRun) return;

    try {
      dataProvider.setUserCoin();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
