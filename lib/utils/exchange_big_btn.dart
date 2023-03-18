import 'package:flutter/material.dart';

import 'constants.dart';

class ExchnageBigBtn extends StatelessWidget {
  final Color? textColor, bgColor;
  final String? text;
  final FontWeight? fontWeight;
  final double? height, width, fontSize, borderRadius;
  final VoidCallback? onTap;

  const ExchnageBigBtn({
    Key? key,
    required this.text,
    this.textColor,
    this.bgColor,
    this.height,
    this.width,
    this.fontSize,
    this.borderRadius,
    this.fontWeight,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: TextButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          backgroundColor: bgColor ?? Colors.blue[900],
        ),
        onPressed: onTap ?? () {},
        child: Text(
          text!,
          style: TextStyle(
            fontSize: fontSize ?? 16,
            color: textColor ?? Colors.white,
            fontWeight: fontWeight ?? FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
