// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:crypto_exchange_app/main.dart';
import 'password_reset_screen.dart';
import 'widgets/utils.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const LoginWidget({super.key, required this.onClickedSignIn});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          SizedBox(
            height: 80,
            width: 80,
            child: Image.asset(
              'assets/images/smile.png',
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          Text('Welcome', style: theme.textTheme.displayMedium),
          const SizedBox(height: 48),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              label: Text('Email'),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _passwordController,
            autofocus: false,
            decoration: InputDecoration(
              label: const Text('Password'),
              border: OutlineInputBorder(),
              suffixIcon: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => _togglePasswordVisibility(),
                child: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility),
              ),
            ),
            textInputAction: TextInputAction.done,
            obscureText: _isPasswordObscured,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.lock_open_rounded),
              label: Text(
                'Sign in',
                style: theme.textTheme.titleMedium!.copyWith(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder())),
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    Utils.showSnackBar('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    Utils.showSnackBar('Wrong password provided for that user.');
                  } else {
                    Utils.showSnackBar(e.message);
                  }
                }
                navigatorKey.currentState!.popUntil((route) => route.isFirst);
              },
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const PasswordResetScreen(),
            )),
            child: Text(
              'Forgot password?',
              style: theme.textTheme.titleMedium!.apply(decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'No Account? ', style: theme.textTheme.titleMedium),
                TextSpan(
                    text: 'Sign Up ',
                    recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignIn,
                    style: theme.textTheme.titleLarge!.apply(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.green,
                      color: Colors.green,
                    )),
              ],
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
