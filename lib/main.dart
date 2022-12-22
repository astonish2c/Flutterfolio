import 'package:crypto_exchange_app/pages/home_page/components/home_tab_bar.dart';
import 'package:crypto_exchange_app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'utils/custom_theme.dart';
import 'pages/home_page/home_page.dart';
import 'pages/market_page/market_page.dart';
import 'pages/holdings_page/holdings_page.dart';
import '../provider/data_provider.dart';
import 'pages/holdings_page/components/holdings_item_transactions.dart';
import 'pages/home_page/components/home_items_list.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<DataProvider>(
            create: (context) => DataProvider(),
          ),
          ListenableProvider<ThemeProvider>(
            create: (context) => ThemeProvider(),
          ),
        ],
        builder: (context, child) => const App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // print('App build');
    return ScreenUtilInit(
      designSize: const Size(1080, 2400),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => Consumer<ThemeProvider>(
        builder: (context, value, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightThemeData,
          darkTheme: darkThemeData,
          themeMode: value.themeMode,
          routes: {
            '/': (context) => const HomePage(),
            MarketPage.routeName: (context) => const MarketPage(),
            HoldingsPage.routeName: (context) => const HoldingsPage(),
            HoldingsItemTransactions.routeName: (context) => const HoldingsItemTransactions(),
            HomeItemsList.routeName: (context) => const HomeItemsList(),
            HomeTabBar.routeName: (context) => const HomeTabBar(),
          },
        ),
        // child: ,
      ),
      // child: ,
    );
  }
}
