import 'package:crypto_exchange_app/Auth/widgets/helper_methods.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import '../../../custom_widgets/custom_elevated_iconButton.dart';
import '/custom_widgets/custom_image.dart';
import '/main.dart';
import '../../widgets/utils.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onClickedSignup;

  const SignUpScreen({super.key, required this.onClickedSignup});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordObscured = true;
  bool _isRetypePasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  void _toggleRetypePasswordVisibility() {
    setState(() {
      _isRetypePasswordObscured = !_isRetypePasswordObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              const CustomImage(imagePath: 'assets/images/writing.png', size: 80),
              const SizedBox(height: 24),
              Text('Let\'s get you signed up', style: theme.textTheme.titleLarge),
              const SizedBox(height: 48),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  label: Text('Email'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_rounded),
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
                decoration: InputDecoration(
                  label: const Text('Password'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => _togglePasswordVisibility(),
                    child: Icon(
                      _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.done,
                obscureText: _isPasswordObscured,
                validator: (password) {
                  if (password != null && password.length < 6) {
                    return 'Your password must be at least 6 characters long.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _retypePasswordController,
                decoration: InputDecoration(
                  label: const Text('Retype password'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_reset_rounded),
                  suffixIcon: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => _toggleRetypePasswordVisibility(),
                    child: Icon(_isRetypePasswordObscured ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                textInputAction: TextInputAction.done,
                obscureText: _isRetypePasswordObscured,
                validator: (retypedPassword) {
                  if (retypedPassword != null && _passwordController.text != _retypePasswordController.text) {
                    return 'Your password does not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomElevatedIconBtn(
                title: 'Sign Up',
                icon: Icons.email,
                onPressed: () async {
                  final bool isValid = _formKey.currentState!.validate();
                  if (!isValid) return;

                  try {
                    await signUp(context, email: _emailController.text, password: _passwordController.text);
                  } on FirebaseAuthException catch (e) {
                    Navigator.of(context).pop();
                    Utils.showSnackBar(e.message);
                  }
                },
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
      ),
    );
  }
}
