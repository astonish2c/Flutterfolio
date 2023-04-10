import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/screens/sign_in_screen/authentication_state.dart';
import '/screens/sign_in_screen/verification_state.dart';

class HomePage extends StatelessWidget {
  static const routeName = 'Home_Page';
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> user) {
            if (user.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (user.hasError) {
              return const Text('Something went wrong');
            } else if (user.hasData) {
              return const VerificationState();
            } else {
              return const AuthenticationState();
            }
          },
        ),
      ),
    );
  }
}
