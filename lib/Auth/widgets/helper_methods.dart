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
  // capture NavigatorState before awaiting to avoid using BuildContext after an async gap
  final navigator = navigatorKey.currentState;

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password.trim());

    // navigate back to root if navigator is still available
    navigator?.popUntil((route) => route.isFirst);
  } on FirebaseAuthException catch (e, st) {
    // ensure progress dialog is removed
    try {
      navigator?.pop();
    } catch (_) {}

    // show precise firebase error
    Utils.showSnackBar(e.message ?? 'Sign in failed', bgColor: Colors.red);
    // also print stack for debugging
    // ignore: avoid_print
    print('signIn FirebaseAuthException: $e\n$st');
  } catch (e, st) {
    try {
      navigator?.pop();
    } catch (_) {}

    // show actual exception message to help debugging
  final msg = e.toString();
    Utils.showSnackBar(msg, bgColor: Colors.red);
    // ignore: avoid_print
    print('signIn unexpected error: $e\n$st');
  }
}

Future<void> signUp(BuildContext context, {required String email, required String password}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  final navigator = navigatorKey.currentState;

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
    navigator?.popUntil((route) => route.isFirst);
  } on FirebaseAuthException catch (e, st) {
    try { navigator?.pop(); } catch (_) {}
    Utils.showSnackBar(e.message ?? 'Sign up failed', bgColor: Colors.red);
    // ignore: avoid_print
    print('signUp FirebaseAuthException: $e\n$st');
  } catch (e, st) {
    try { navigator?.pop(); } catch (_) {}
    Utils.showSnackBar(e.toString(), bgColor: Colors.red);
    // ignore: avoid_print
    print('signUp unexpected error: $e\n$st');
  }
}

Future<void> resetPassword(BuildContext context, {required String email}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );
  final navigator = navigatorKey.currentState;

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());

    // close progress dialog before any navigation
    try {
      navigator?.pop();
    } catch (_) {}

    // return to root (if desired)
    navigator?.popUntil((route) => route.isFirst);

    Utils.showSnackBar('Password reset email has been sent.', bgColor: Colors.green);
  } on FirebaseAuthException catch (e, st) {
    try { navigator?.pop(); } catch (_) {}
    Utils.showSnackBar(e.message ?? 'Password reset failed', bgColor: Colors.red);
    // ignore: avoid_print
    print('resetPassword FirebaseAuthException: $e\n$st');
  } catch (e, st) {
    try { navigator?.pop(); } catch (_) {}
    Utils.showSnackBar(e.toString(), bgColor: Colors.red);
    // ignore: avoid_print
    print('resetPassword unexpected error: $e\n$st');
  }
}
