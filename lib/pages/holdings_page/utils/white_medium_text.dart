import 'package:flutter/material.dart';

class WhiteMediumText extends StatelessWidget {
  final String text;

  const WhiteMediumText({
    Key? key,
    required this.textTheme,
    required this.text,
  }) : super(key: key);

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textTheme.headline4!.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
