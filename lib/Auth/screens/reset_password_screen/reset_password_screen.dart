import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:Flutterfolio/Auth/widgets/helper_methods.dart';
import 'package:Flutterfolio/custom_widgets/custom_elevated_iconButton.dart';
import '/custom_widgets/custom_image.dart';
import '../../widgets/utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = 'Password_Reset_Screen';
  const ResetPasswordScreen({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Password reset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              const CustomImage(imagePath: 'assets/images/happiness.png', size: 120),
              const SizedBox(height: 24),
              FittedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('We have got your back', style: theme.textTheme.titleLarge),
                ),
              ),
              const SizedBox(height: 56),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  label: Text('Email'),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_rounded),
                ),
                autofocus: false,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please provide an email';
                  } else if (EmailValidator.validate(_emailController.text.trim()) == false) {
                    return 'Please provide a valid email';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 24),
              CustomElevatedIconBtn(
                  title: 'Reset password',
                  icon: Icons.lock_reset_rounded,
                  onPressed: () async {
                    final bool isFormValid = _formKey.currentState!.validate();
                    if (!isFormValid) return;

                    try {
                      await resetPassword(context, email: _emailController.text);
                      if (widget.scaffoldKey != null && widget.scaffoldKey!.currentState!.isDrawerOpen && context.mounted) {
                        Navigator.of(context).pop();
                      }
                    } on FirebaseAuthException catch (e) {
                      Navigator.of(context).pop();
                      if (e.code == 'user-not-found') {
                        Utils.showSnackBar('No user found for that email.');
                      } else {
                        Utils.showSnackBar(e.message);
                      }
                    }
                  }),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
