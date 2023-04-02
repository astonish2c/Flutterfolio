import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Ok',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
      title: const Text(
        'Oh snap!',
        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.infinity,
        child: Text(
          '''$error''',
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),
    );
  }
}
