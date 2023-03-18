import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;
  final VoidCallback? onPressed;

  const CustomIconButton({
    Key? key,
    required this.icon,
    this.color,
    this.size,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: onPressed ?? () {},
      icon: Icon(
        icon,
        size: size ?? 16,
        color: color ?? Theme.of(context).iconTheme.color,
      ),
    );
  }
}
