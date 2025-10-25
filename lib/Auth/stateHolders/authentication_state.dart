import 'package:flutter/material.dart';
import 'package:flutterfolio/Auth/screens/signup_screen/signUp_screen.dart';

import '../screens/signIn_screen/signIn_screen.dart';

class AuthenticationState extends StatefulWidget {
  const AuthenticationState({super.key});

  @override
  State<AuthenticationState> createState() => _AuthenticationStateState();
}

class _AuthenticationStateState extends State<AuthenticationState> {
  bool isLogin = true;

  void toggleIsLogin() => setState(() => isLogin = !isLogin);

  @override
  Widget build(BuildContext context) {
    return isLogin ? SignInScreen(onClickedSignIn: toggleIsLogin) : SignUpScreen(onClickedSignup: toggleIsLogin);
  }
}
