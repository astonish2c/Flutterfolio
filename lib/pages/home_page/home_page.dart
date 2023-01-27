import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/data_provider.dart';
import '../../utils/nav_bar.dart';
import 'components/home_app_bar.dart';
import 'components/home_header_section.dart';
import 'components/home_portfolio_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<DataProvider>(context, listen: false).setUserCoin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const HomeAppBar(),
      body: Column(
        children: const [
          HomeHeader(),
          SizedBox(height: 12),
          Expanded(
            child: HomePortfolio(),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(currentIndex: 0),
    );
  }
}
