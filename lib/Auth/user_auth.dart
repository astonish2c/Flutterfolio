import 'package:Flutterfolio/provider/userCoins_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'stateHolders/authentication_state.dart';
import 'stateHolders/verification_state.dart';

class UserAuth extends StatelessWidget {
  static const routeName = 'Home_Screen';

  const UserAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> user) {
        if (user.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (user.hasError) {
          return const Text('Something went wrong');
        } else if (user.hasData) {
          final User? localUser = user.data;
          // Provider.of<UserCoinsProvider>(context).updateUser(localUser!);
          return VerificationState(localUser: localUser);
        } else {
          return const AuthenticationState();
        }
      },
    );
  }
}
