import 'package:flutter/material.dart';

import 'signup_widget.dart';
import 'login_widget.dart';

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
    return isLogin ? LoginWidget(onClickedSignIn: toggleIsLogin) : SignupWidget(onClickedSignup: toggleIsLogin);
  }
}
