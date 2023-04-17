import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {
  const CustomRoundButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TextButton(
      child: Text(
        title,
        style: theme.textTheme.titleMedium,
      ),
      style: TextButton.styleFrom(
        side: BorderSide(width: 1, color: theme.colorScheme.onBackground),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: onPressed ?? null,
    );
  }
}
