import 'package:flutter/material.dart';

class Utils {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerState = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text, {Color? bgColor}) {
    if (text == null) return;

    final SnackBar snackBar = SnackBar(content: Text(text), backgroundColor: bgColor ?? Colors.red);

    scaffoldMessengerState.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
