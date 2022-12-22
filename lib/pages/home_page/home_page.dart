import 'package:flutter/material.dart';

import '../../utils/nav_bar.dart';
import 'components/home_app_bar.dart';
import 'components/home_header_section.dart';
import 'components/home_portfolio_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
