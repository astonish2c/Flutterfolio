// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, required this.sendVerificationEmail, required this.canSendEmailVerification, required this.remainingSeconds});

  final VoidCallback sendVerificationEmail;
  final bool canSendEmailVerification;
  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Almost There'),
      ),
      body: Column(
        children: [
          Spacer(),
          SizedBox(
            height: 120,
            width: 120,
            child: Image.asset(
              'assets/images/happiness.png',
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 56),
          Center(
            child: Text(
              'A verification email has been sent to your mail.',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 24),
          SizedBox(
            height: 50,
            width: 250,
            child: ElevatedButton.icon(
              style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder())),
              icon: Icon(Icons.email_rounded),
              label: Text(
                canSendEmailVerification ? 'Resent email' : 'Resent email in $remainingSeconds',
                style: theme.textTheme.titleMedium,
              ),
              onPressed: canSendEmailVerification ? sendVerificationEmail : null,
            ),
          ),
          SizedBox(height: 18),
          SizedBox(
            height: 50,
            width: 250,
            child: TextButton(
              style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder())),
              child: Text(
                'Cancel',
                style: theme.textTheme.titleMedium,
              ),
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
