import 'package:flutter/material.dart';
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
            navigateToPage(context, const HoldingsPage());
          }
          if (_selectedIndex == 1) {
            navigateToPage(context, const MarketPage());
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

  Future<Widget> buildPageAsync(Widget page) async {
    return Future.microtask(() {
      return page;
    });
  }

  void navigateToPage(BuildContext context, Widget getPage) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => getPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin = const Offset(0, 0);
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
