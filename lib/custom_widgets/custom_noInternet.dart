import 'package:flutter/material.dart';

import 'custom_image.dart';
import 'custom_roundButton.dart';

class CustomNoInternet extends StatelessWidget {
  const CustomNoInternet({super.key, required this.error, this.onPressed});

  final String error;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImage(imagePath: 'assets/images/no-wifi.png', size: 130),
        SizedBox(height: 8),
        Text(error, style: theme.textTheme.titleMedium),
        SizedBox(height: 32),
        CustomRoundButton(title: 'Try again', onPressed: onPressed),
      ],
    );
  }
}
