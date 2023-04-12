import 'package:flutter/material.dart';

import '../screens/portfolio_screen/portfolio_screen.dart';
import '../screens/market_screen/market_screen.dart';
import 'helper_methods.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;

  const CustomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBarTheme(
      data: Theme.of(context).bottomNavigationBarTheme,
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (screenIndex) {
          setState(() {
            _selectedIndex = screenIndex;
          });
          if (_selectedIndex == 0) {
            navigateToPage(context, const PortfolioScreen());
          }
          if (_selectedIndex == 1) {
            navigateToPage(context, const MarketScreen());
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_rounded),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Market',
          ),
        ],
      ),
    );
  }
}
