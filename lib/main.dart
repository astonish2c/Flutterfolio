import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/custom_theme.dart';
import '/screens/home_screen/home_page.dart';
import 'screens/add_coins_screen/add_coins_Screen.dart';
import 'screens/tab_screen/tab_screen.dart';
import 'screens/transactions_screen/transactions_screen.dart';
import 'screens/market_screen/market_screen.dart';
import '/provider/theme_provider.dart';
import '/provider/all_coins_provider.dart';
import '/provider/user_coins_provider.dart';

late Box box;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('themeBox');

  await Firebase.initializeApp();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<AllCoinsProvider>(
            create: (context) => AllCoinsProvider(),
          ),
          ChangeNotifierProvider<UserCoinsProvider>(
            create: (context) => UserCoinsProvider(),
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
    return ValueListenableBuilder(
      valueListenable: Hive.box('themeBox').listenable(),
      builder: (context, box, _) {
        final bool isDarkTheme = box.get('isDarkTheme');

        print('App Build');
        return MaterialApp(
          title: 'Crypto Firebase',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
          themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          routes: {
            '/': (context) => const HoldingsPage(),
            MarketScreen.routeName: (context) => const MarketScreen(),
            TransactionsScreen.routeName: (context) => const TransactionsScreen(),
            AddCoinsScreen.routeName: (context) => const AddCoinsScreen(),
            TabScreen.routeName: (context) => const TabScreen(),
          },
        );
      },
    );
  }
}
