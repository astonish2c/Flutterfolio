import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import '/screens/home_screen/home_page.dart';
import '/provider/theme_provider.dart';
import 'screens/add_coins_screen/add_coins_Screen.dart';
import 'screens/tab_screen/tab_screen.dart';
import 'screens/transactions_screen/transactions_screen.dart';
import 'screens/market_screen/market_screen.dart';
import 'custom_widgets/custom_theme.dart';
import '../provider/data_provider.dart';

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
        theme: ThemeData.from(colorScheme: lightColorScheme),
        darkTheme: ThemeData.from(colorScheme: darkColorScheme),
        themeMode: value.themeMode,
        routes: {
          '/': (context) => const HoldingsPage(),
          MarketScreen.routeName: (context) => const MarketScreen(),
          TransactionsScreen.routeName: (context) => const TransactionsScreen(),
          AddCoinsScreen.routeName: (context) => const AddCoinsScreen(),
          TabScreen.routeName: (context) => const TabScreen(),
        },
      ),
    );
  }
}
