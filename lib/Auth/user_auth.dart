import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          return VerificationState(localUser: localUser);
        } else {
          return const AuthenticationState();
        }
      },
    );
  }
}
