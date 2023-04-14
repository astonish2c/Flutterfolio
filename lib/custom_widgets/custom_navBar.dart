import 'package:flutter/material.dart';

import '../screens/portfolio_screen/portfolio_screen.dart';
import '../screens/market_screen/market_screen.dart';

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
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });

        if (_selectedIndex == 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(pageBuilder: (_, __, ___) => const PortfolioScreen()),
          );
        } else if (_selectedIndex == 1) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const MarketScreen(),
            ),
          );
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.pie_chart_rounded),
          label: 'Portfolio',
        ),
        NavigationDestination(
          icon: Icon(Icons.auto_graph_rounded),
          label: 'Market',
        ),
      ],
    );
  }
}
