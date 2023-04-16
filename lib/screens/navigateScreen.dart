import 'package:flutter/material.dart';

import '/screens/market_screen/market_screen.dart';
import '/screens/portfolio_screen/portfolio_screen.dart';

class NavigateScreen extends StatefulWidget {
  const NavigateScreen({super.key});

  @override
  State<NavigateScreen> createState() => _NavigateScreenState();
}

class _NavigateScreenState extends State<NavigateScreen> {
  int _currentIndex = 0;

  final _screens = [
    const PortfolioScreen(),
    const MarketScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(milliseconds: 300),
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
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
      ),
    );
  }
}
