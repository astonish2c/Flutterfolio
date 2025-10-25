import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfolio/custom_widgets/custom_image.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, required this.sendVerificationEmail, required this.canSendEmailVerification, required this.remainingSeconds});

  final VoidCallback sendVerificationEmail;
  final bool canSendEmailVerification;
  final int remainingSeconds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent, title: const Text('Almost There')),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const CustomImage(imagePath: 'assets/images/happiness.png', size: 120),
            const SizedBox(height: 56),
            Center(
              child: Text('Verification email sent succesfully.', textAlign: TextAlign.center, style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton.icon(
                style: ButtonStyle(shape: WidgetStateProperty.all(const RoundedRectangleBorder())),
                icon: const Icon(Icons.email_rounded),
                label: Text(canSendEmailVerification ? 'Resent email' : 'Resent email in $remainingSeconds', style: theme.textTheme.titleMedium),
                onPressed: canSendEmailVerification ? sendVerificationEmail : null,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 50,
              width: 250,
              child: TextButton(
                style: ButtonStyle(shape: WidgetStateProperty.all(const RoundedRectangleBorder())),
                child: Text('Cancel', style: theme.textTheme.titleMedium),
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
