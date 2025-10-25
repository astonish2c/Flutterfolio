import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Ok', style: TextStyle(fontSize: 14)),
          ),
        ),
      ],
      title: Text(
        'Oh snap!',
        style: TextStyle(fontSize: 18, color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.infinity,
        child: Text(error, style: TextStyle(fontSize: 14, color: theme.colorScheme.onPrimaryContainer)),
      ),
    );
  }
}
