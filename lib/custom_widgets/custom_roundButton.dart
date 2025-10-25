import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {
  const CustomRoundButton({super.key, required this.onPressed, required this.title});

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TextButton(
      style: TextButton.styleFrom(
        side: BorderSide(width: 1, color: theme.colorScheme.onSurface),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(title, style: theme.textTheme.titleMedium),
    );
  }
}
