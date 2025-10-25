import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.imagePath,
    this.size,
  });

  final String imagePath;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      height: size ?? 130,
      width: size ?? 130,
      child: Image.asset(imagePath, color: theme.colorScheme.onPrimaryContainer),
    );
  }
}
