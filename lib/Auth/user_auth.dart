// ...existing code...
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'stateHolders/authentication_state.dart';
import 'stateHolders/verification_state.dart';

class UserAuth extends StatefulWidget {
  static const routeName = 'Home_Screen';

  const UserAuth({super.key});

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  late final Stream<User?> _authStream;

  //AI Wrote This Part
  @override
  void initState() {
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStream,
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
// ...existing code...