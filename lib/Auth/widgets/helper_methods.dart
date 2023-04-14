import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'utils.dart';

Future<void> signIn(BuildContext context, {required String email, required String password}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email.trim(),
    password: password.trim(),
  );

  navigatorKey.currentState!.popUntil((route) => route.isFirst);
}

Future<void> signUp(BuildContext context, {required String email, required String password}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email.trim(),
    password: password.trim(),
  );

  navigatorKey.currentState!.popUntil((route) => route.isFirst);
}

Future<void> resetPassword(BuildContext context, {required String email}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  await FirebaseAuth.instance.sendPasswordResetEmail(
    email: email.trim(),
  );

  navigatorKey.currentState!.popUntil((route) => route.isFirst);

  Utils.showSnackBar('Password reset email has been sent.', bgColor: Colors.green);
}
