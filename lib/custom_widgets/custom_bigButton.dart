import 'package:flutter/material.dart';

class CustomBigButton extends StatelessWidget {
  const CustomBigButton({super.key, required this.text, this.textColor, this.bgColor, this.height, this.width, this.fontSize, this.borderRadius, this.fontWeight, this.onTap, this.child});

  final Color? textColor, bgColor;
  final String? text;
  final FontWeight? fontWeight;
  final double? height, width, fontSize, borderRadius;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: bgColor,
        ),
        onPressed: onTap,
        child:
            child ??
            Text(
              text!,
              style: TextStyle(fontSize: fontSize ?? 16, color: textColor ?? Colors.white, fontWeight: fontWeight ?? FontWeight.w700),
            ),
      ),
    );
  }
}
