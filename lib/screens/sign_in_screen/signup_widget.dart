import 'package:crypto_exchange_app/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import 'widgets/utils.dart';

class SignupWidget extends StatefulWidget {
  final VoidCallback onClickedSignup;

  const SignupWidget({super.key, required this.onClickedSignup});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('Email'),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              validator: (email) {
                if (email != null && !EmailValidator.validate(email)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                label: Text('Password'),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              obscureText: true,
              validator: (password) {
                if (password != null && password.length < 6) {
                  return 'Your password must be at least 6 characters long.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock_open_rounded),
                label: Text(
                  'Sign Up',
                  style: theme.textTheme.titleMedium!.copyWith(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder())),
                onPressed: () async {
                  final bool isValid = _formKey.currentState!.validate();

                  if (!isValid) return;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );

                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                  } on FirebaseAuthException catch (e) {
                    Utils.showSnackBar(e.message);
                  }
                  navigatorKey.currentState!.popUntil((route) => route.isFirst);
                },
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Already have an account? ', style: theme.textTheme.titleMedium),
                  TextSpan(
                      text: 'Sign In ',
                      recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignup,
                      style: theme.textTheme.titleLarge!.apply(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.green,
                        color: Colors.green,
                      )),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
