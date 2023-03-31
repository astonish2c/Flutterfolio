// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../provider/data_provider.dart';
import '../../utils/nav_bar.dart';
import 'components/home_app_bar.dart';
import 'components/balance_section.dart';
import 'components/portfolio_section.dart';
import '/pages/market_page/market_page.dart';
import '/utils/constants.dart';

class HoldingsPage extends StatefulWidget {
  const HoldingsPage({super.key});

  @override
  State<HoldingsPage> createState() => _HoldingsPageState();
}

class _HoldingsPageState extends State<HoldingsPage> {
  // late StreamSubscription<DatabaseEvent> _streamSubscription;
  // bool _hasErrorUserCoins = false;

  Future<void> setValues() async {
    DataProvider dataProvider = context.read<DataProvider>();

    if (!dataProvider.isFirstRunUser) return;

    try {
      await dataProvider.setUserCoin();
      await dataProvider.setDbCoins();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setValues();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoadingUserCoin = context.select((DataProvider dataProvider) => dataProvider.isLoadingUserCoin);
    final bool hasErrorUserCoin = context.select((DataProvider dataProvider) => dataProvider.hasErrorUserCoin);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const HomeAppBar(),
      body: isLoadingUserCoin
          ? ShimmerLoading()
          : hasErrorUserCoin
              ? CustomError(error: 'Please make sure your internet is connected and try again.')
              : Column(
                  children: const [
                    Balance(),
                    SizedBox(height: 12),
                    Expanded(
                      child: Portfolio(),
                    ),
                  ],
                ),
      bottomNavigationBar: const NavBar(currentIndex: 0),
      floatingActionButton: !hasErrorUserCoin
          ? Text('')
          : FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () async {
                final dataProvider = context.read<DataProvider>();
                try {
                  setState(() {
                    dataProvider.hasErrorDatabase = false;
                  });
                  await dataProvider.setUserCoin();
                  await dataProvider.setDbCoins();
                } catch (e) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Ok',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                        title: const Text(
                          'Oh snap!',
                          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        content: SizedBox(
                          width: double.infinity,
                          child: Text(
                            '$e',
                            style: const TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.blue,
      highlightColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Skelton(height: 180, width: double.infinity),
            SizedBox(height: 30),
            Skelton(height: 20, width: 120),
            SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: 12,
                itemBuilder: (context, index) => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Skelton(
                      height: 50,
                      width: 50,
                      borderCircle: 32,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Skelton(width: 60),
                        SizedBox(height: 16 / 4),
                        const Skelton(width: 30),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Skelton(width: 60),
                        SizedBox(height: 16 / 4),
                        const Skelton(width: 40),
                      ],
                    ),
                  ],
                ),
                separatorBuilder: (BuildContext context, int index) => SizedBox(height: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
