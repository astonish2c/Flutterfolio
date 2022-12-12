// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants.dart';
import '../../holdings page/components/icon_btn_zero_padding.dart';

class ExchangeCoinRow extends StatelessWidget {
  final String iconUrl;
  final String coinTitle;
  final String hintText;
  final bool showTrail;

  const ExchangeCoinRow({
    Key? key,
    required this.iconUrl,
    required this.coinTitle,
    required this.hintText,
    required this.showTrail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          //Coin Row
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Image.asset(iconUrl),
              ),
              SizedBox(width: defaultPadding / 4),
              Text(coinTitle),
              SizedBox(width: defaultPadding / 4),
              const IconBtnZeroPadding(icon: Icons.arrow_drop_down),
              SizedBox(width: defaultPadding / 4),
            ],
          ),
          //Input Field
          Expanded(
            child: TextField(
              // scrollPadding: ,
              decoration: InputDecoration.collapsed(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ),
          ),
          //Max Btn
          if (showTrail)
            CustomTextBtn(
              text: 'MAX',
            ),
        ],
      ),
    );
  }
}

class CustomTextBtn extends StatelessWidget {
  final double? fontSize, width, height;
  final Color? textColor, bgColor;
  final VoidCallback? onTap;
  final String text;
  final EdgeInsets? padding;

  const CustomTextBtn({
    Key? key,
    this.textColor,
    this.bgColor,
    this.onTap,
    required this.text,
    this.fontSize,
    this.padding,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap ?? () {},
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        visualDensity: VisualDensity.standard,
        backgroundColor: bgColor ?? Colors.white,
        padding: padding ?? EdgeInsets.symmetric(horizontal: defaultPadding / 2, vertical: defaultPadding * 0.6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.blue,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
