import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/screens/home_screen/home_page.dart';
import 'verify_email_screen.dart';
import 'widgets/utils.dart';

class VerificationState extends StatefulWidget {
  const VerificationState({super.key});

  @override
  State<VerificationState> createState() => _VerificationStateState();
}

class _VerificationStateState extends State<VerificationState> {
  Timer? _timerCheckEmailVerification;
  Timer? _timerRemainingSeconds;

  bool _isEmailVerified = false;
  bool _canSendEmailVerification = true;

  int _remainingSeconds = 30;

  @override
  void initState() {
    super.initState();

    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!_isEmailVerified) {
      sendEmailVerification();

      _timerCheckEmailVerification = Timer.periodic(const Duration(seconds: 3), (timer) => checkEmailVerification());
    }
  }

  @override
  void dispose() {
    _timerCheckEmailVerification?.cancel();
    _timerRemainingSeconds?.cancel();
    super.dispose();
  }

  Future<void> sendEmailVerification() async {
    final User user = FirebaseAuth.instance.currentUser!;

    try {
      setState(() {
        _canSendEmailVerification = false;
      });

      await user.sendEmailVerification();

      _timerRemainingSeconds = scheduledSendEmailVerification();

      Utils.showSnackBar('Email verification sent succesfully.', bgColor: Colors.green);
    } catch (e) {
      Utils.showSnackBar(e.toString(), bgColor: Colors.red);

      scheduledSendEmailVerification();
    }
  }

  void checkEmailVerification() {
    final User user = FirebaseAuth.instance.currentUser!;

    user.reload();

    setState(() {
      _isEmailVerified = user.emailVerified;
    });

    if (user.emailVerified) {
      _timerCheckEmailVerification?.cancel();
    }
  }

  Timer scheduledSendEmailVerification() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds == 0) {
        timer.cancel();
        setState(() {
          _canSendEmailVerification = true;
          _remainingSeconds = 30;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isEmailVerified
        ? const HomeScreen()
        : VerifyEmailScreen(
            sendVerificationEmail: sendEmailVerification,
            canSendEmailVerification: _canSendEmailVerification,
            remainingSeconds: _remainingSeconds,
          );
  }
}
