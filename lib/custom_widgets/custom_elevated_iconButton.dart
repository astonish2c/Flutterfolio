import 'package:flutter/material.dart';

class CustomElevatedIconBtn extends StatelessWidget {
  const CustomElevatedIconBtn({super.key, required this.title, required this.icon, required this.onPressed, this.size});

  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      height: size ?? 60,
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
        label: Text(
          title,
          style: theme.textTheme.titleMedium!.copyWith(fontSize: 22),
        ),
        style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder())),
        onPressed: onPressed,
      ),
    );
  }
}
