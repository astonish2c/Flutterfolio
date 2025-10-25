import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '/screens/onBoarding_screen/onBoarding_screen.dart';
import 'Auth/screens/reset_password_screen/reset_password_screen.dart';
import 'custom_widgets/custom_theme.dart';
import 'screens/addCoins_screen/addCoins_screen.dart';
import 'screens/portfolio_screen/portfolio_screen.dart';
import 'Auth/user_auth.dart';
import 'Auth/widgets/utils.dart';
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
  await Hive.openBox('configs');

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
      valueListenable: Hive.box('configs').listenable(),
      builder: (context, box, _) {
        final bool isDarkTheme = box.get('isDarkTheme') ?? false;
        final bool isFirstRun = box.get('isFirstRun') ?? true;

        return MaterialApp(
          scaffoldMessengerKey: Utils.scaffoldMessengerState,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Flutterfolio',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          home: isFirstRun ? const OnBoardingScreen() : const UserAuth(),
          routes: {
            UserAuth.routeName: (context) => const UserAuth(),
            PortfolioScreen.routeName: (context) => const PortfolioScreen(),
            MarketScreen.routeName: (context) => const MarketScreen(),
            TransactionsScreen.routeName: (context) => const TransactionsScreen(),
            AddCoinsScreen.routeName: (context) => const AddCoinsScreen(),
            TabScreen.routeName: (context) => const TabScreen(),
            ResetPasswordScreen.routeName: (context) => const ResetPasswordScreen(),
          },
        );
      },
    );
  }
}
