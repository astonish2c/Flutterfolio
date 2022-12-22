import 'package:flutter/material.dart';

class GreySmallText extends StatelessWidget {
  final String text;

  const GreySmallText({
    Key? key,
    required this.textTheme,
    required this.text,
  }) : super(key: key);

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textTheme.bodySmall!.copyWith(
        fontSize: 14,
        color: Colors.grey[400],
      ),
    );
  }
}
