// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:crypto_exchange_app/pages/holdings_page/holdings_page.dart';
import 'package:crypto_exchange_app/pages/settings_pages/settings_page.dart';
import 'package:flutter/material.dart';

import '../pages/exchange_page/exchange_page.dart';
import '../pages/home_page/home_page.dart';
import '../pages/market_page/market_page.dart';

class NavBar extends StatefulWidget {
  final int currentIndex;

  const NavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = widget.currentIndex;
    });
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBarTheme(
      data: Theme.of(context).bottomNavigationBarTheme,
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
          if (_selectedIndex == 0) {
            navigateToPage(context, HomePage());
          }
          if (_selectedIndex == 1) {
            navigateToPage(context, HoldingsPage());
          }
          if (_selectedIndex == 2) {
            navigateToPage(context, ExchangePage());
          }
          if (_selectedIndex == 3) {
            navigateToPage(context, MarketPage());
          }
          if (_selectedIndex == 4) {
            navigateToPage(context, SettingsPage());
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_rounded),
            label: 'Holdings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_vertical_circle_rounded),
            label: 'Exchange',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Future<Widget> buildPageAsync(Widget page) async {
    return Future.microtask(() {
      return page;
    });
  }

  void navigateToPage(BuildContext context, Widget getPage) async {
    // var page = await buildPageAsync(getPage);
    // var route = MaterialPageRoute(builder: (_) => page);
    // Navigator.pushReplacement(context, route);

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => getPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin = Offset(0, 0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
