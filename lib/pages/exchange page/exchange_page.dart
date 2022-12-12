// ignore_for_file: prefer_const_constructors

import 'package:crypto_exchange_app/pages/exchange%20page/exchange_widget.dart';
import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:crypto_exchange_app/utils/nav_bar.dart';
import 'package:crypto_exchange_app/utils/scaffold_bg.dart';
import 'package:flutter/material.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  int _pageIndex = 0;

  void _changePage(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldBG(
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: ExchangeWidget(
              pageIndex: _pageIndex,
              changePageValue: _changePage,
            ),
          ),
          bottomNavigationBar: NavBar(currentIndex: 2),
        ),
      ),
    );
  }
}
