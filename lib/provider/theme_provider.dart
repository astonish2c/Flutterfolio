import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Auth/stateHolders/authentication_state.dart';
import '../Auth/stateHolders/verification_state.dart';

class ThemeProvider with ChangeNotifier {
  late bool _isDarkTheme;

  Future<void> toggleThemeMode() async {
    Box box = await Hive.openBox('configs');

    _isDarkTheme = box.get('isDarkTheme') ?? false;

    _isDarkTheme = !_isDarkTheme;

    await box.put('isDarkTheme', _isDarkTheme);

    notifyListeners();
  }

  StreamBuilder<User?> userAuthChanges() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> user) {
        if (user.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (user.hasError) {
          return const Text('Something went wrong');
        } else if (user.hasData) {
          final User? localUser = user.data;
          return VerificationState(localUser: localUser);
        } else {
          return const AuthenticationState();
        }
      },
    );
  }
}
