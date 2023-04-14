import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '/screens/home_screen/password_reset_screen.dart';
import 'custom_widgets/custom_theme.dart';
import 'screens/addCoins_screen/addCoins_screen.dart';
import 'screens/portfolio_screen/portfolio_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/home_screen/widgets/utils.dart';
import 'screens/tab_screen/tab_screen.dart';
import 'screens/transactions_screen/transactions_screen.dart';
import 'screens/market_screen/market_screen.dart';
import '/provider/theme_provider.dart';
import 'provider/allCoins_provider.dart';
import 'provider/userCoins_provider.dart';

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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('themeBox').listenable(),
      builder: (context, box, _) {
        final bool isDarkTheme = box.get('isDarkTheme') ?? false;

        return MaterialApp(
          scaffoldMessengerKey: Utils.scaffoldMessengerState,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Crypto Firebase',
          themeAnimationDuration: const Duration(milliseconds: 200),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
          routes: {
            HomeScreen.routeName: (context) => const HomeScreen(),
            PortfolioScreen.routeName: (context) => const PortfolioScreen(),
            MarketScreen.routeName: (context) => const MarketScreen(),
            TransactionsScreen.routeName: (context) => const TransactionsScreen(),
            AddCoinsScreen.routeName: (context) => const AddCoinsScreen(),
            TabScreen.routeName: (context) => const TabScreen(),
            PasswordResetScreen.routeName: (context) => const PasswordResetScreen(),
          },
        );
      },
    );
  }
}
