import 'package:flutter/material.dart';

import '../components/signin_widget.dart';
import '../components/signup_widget.dart';

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
    return isLogin ? SigninWidget(onClickedSignIn: toggleIsLogin) : SignupWidget(onClickedSignup: toggleIsLogin);
  }
}
