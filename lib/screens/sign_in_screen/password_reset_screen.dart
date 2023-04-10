import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'widgets/utils.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('Email'),
                border: OutlineInputBorder(),
              ),
              autofocus: false,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock_reset_rounded),
                label: Text(
                  'Reset password',
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
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: _emailController.text.trim(),
                    );

                    Utils.showSnackBar('Password reset email has been sent.', bgColor: Colors.green);

                    navigatorKey.currentState!.popUntil((route) => route.isFirst);
                  } on FirebaseAuthException catch (e) {
                    Navigator.of(context).pop();
                    if (e.code == 'user-not-found') {
                      Utils.showSnackBar('No user found for that email.');
                    } else {
                      Utils.showSnackBar(e.message);
                    }
                  }
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
