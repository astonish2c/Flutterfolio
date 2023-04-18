import 'package:flutter/material.dart';

import 'custom_roundButton.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key, required this.imagePath, required this.error, required this.onPressed, required this.buttonTitle, this.imageSize});

  final String imagePath;
  final String error;
  final VoidCallback onPressed;
  final String buttonTitle;
  final double? imageSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: imageSize ?? 130,
            width: imageSize ?? 130,
          ),
          SizedBox(height: 12),
          Text(error),
          SizedBox(height: 32),
          CustomRoundButton(onPressed: onPressed, title: buttonTitle),
        ],
      ),
    );
  }
}
