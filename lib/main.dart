import 'package:crypto_exchange_app/pages/home_page/components/home_tab_bar.dart';
import 'package:crypto_exchange_app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'utils/custom_theme.dart';
import 'pages/home_page/home_page.dart';
import 'pages/market_page/market_page.dart';
import '../provider/data_provider.dart';
import 'pages/home_page/components/transactions_screen.dart';
import 'pages/home_page/components/home_items_list.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
    return Consumer<ThemeProvider>(
      builder: (context, value, child) => MaterialApp(
        title: 'Crypto Firebase',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: value.themeMode,
        routes: {
          '/': (context) => const HoldingsPage(),
          MarketPage.routeName: (context) => const MarketPage(),
          TransactionsScreen.routeName: (context) => const TransactionsScreen(),
          HomeItemsList.routeName: (context) => const HomeItemsList(),
          HomeTabBar.routeName: (context) => const HomeTabBar(),
        },
      ),
    );
  }
}
