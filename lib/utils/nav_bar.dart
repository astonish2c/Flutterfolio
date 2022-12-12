// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:crypto_exchange_app/pages/exchange%20page/exchange_page.dart';
import 'package:crypto_exchange_app/pages/holdings%20page/holdings_page.dart';
import 'package:crypto_exchange_app/pages/settings%20pages/settings_page.dart';
import 'package:flutter/material.dart';

import '../pages/home page/components/nav_bar_item.dart';
import '../pages/home page/home_page.dart';
import '../pages/market page/market_page.dart';
import 'constants.dart';

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

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // if (_selectedIndex < widget.currentIndex) {
          //   begin = Offset(-1, 0);
          // } else if (_selectedIndex > widget.currentIndex) {
          //   begin = Offset(1, 0);
          // } else {
          //   begin = Offset(0, 0);
          // }

          Offset begin = Offset(0, 0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },

        transitionDuration: Duration(milliseconds: 300),
        // reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        height: 50,
        indicatorColor: darkBlue.withOpacity(0.2),
        backgroundColor: lightBlue,
        labelTextStyle: MaterialStateProperty.all(
          TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ),
      child: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
          if (value == 0) {
            navigateToPage(context, HomePage());
          } else if (value == 1) {
            navigateToPage(context, HoldingsPage());
          } else if (value == 2) {
            navigateToPage(context, ExchangePage());
          } else if (value == 3) {
            navigateToPage(context, MarketPage());
          } else if (value == 4) {
            navigateToPage(context, SettingsPage());
          }
        },
        destinations: [
          NavgationBarItem(
            iconUrl: 'assets/icons/home.svg',
            label: 'Home',
          ),
          NavgationBarItem(
            iconUrl: 'assets/icons/pie_chart.svg',
            label: 'Holdings',
          ),
          NavgationBarItem(
            iconUrl: 'assets/icons/exchange.svg',
            label: 'Exchange',
          ),
          NavgationBarItem(
            iconUrl: 'assets/icons/bar_chart.svg',
            label: 'Market',
          ),
          NavgationBarItem(
            iconUrl: 'assets/icons/settings.svg',
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
