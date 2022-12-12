import 'package:crypto_exchange_app/pages/holdings%20page/components/coin_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../pages/home page/home_page.dart';
import '../pages/market%20page/market_page.dart';
import '../pages/holdings%20page/holdings_page.dart';
import '../provider/data_provider.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final newTextTheme = Theme.of(context).textTheme.apply(
          fontFamily: 'Montserrat',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        );
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      builder: (context, child) {
        return ScreenUtilInit(
          designSize: const Size(1080, 2400),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.transparent,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              textTheme: newTextTheme,
            ),
            routes: {
              '/': (context) => const HomePage(),
              MarketPage.routeName: (context) => const MarketPage(),
              HoldingsPage.routeName: (context) => const HoldingsPage(),
              CoinDetailScreen.routeName: (context) => const CoinDetailScreen(),
            },
          ),
        );
      },
    );
  }
}
