// ignore_for_file: prefer_const_constructors

import 'package:crypto_exchange_app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'custom_icon_button.dart';

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
    return Consumer<ThemeProvider>(
      builder: (context, value, child) => Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        decoration: BoxDecoration(
          color: value.isDark ? Colors.white12 : Colors.black12,
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
                SizedBox(width: 4),
                Text(coinTitle),
                SizedBox(width: 4),
                const CustomIconButton(icon: Icons.arrow_drop_down),
                SizedBox(width: 4),
              ],
            ),
            //Input Field
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
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
      ),
      // child: ,
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
    ThemeData theme = Theme.of(context);
    return TextButton(
      onPressed: onTap ?? () {},
      style: theme.textButtonTheme.style,
      // TextButton.styleFrom(
      //   minimumSize: Size.zero,
      //   visualDensity: VisualDensity.standard,
      //   // backgroundColor: bgColor ?? theme.textButtonTheme.style,
      //   padding: padding ?? EdgeInsets.symmetric(horizontal: defaultPadding / 2, vertical: defaultPadding * 0.6),
      // ),
      child: Text(
        text,
        // TextStyle(
        //   // color: textColor ?? Colors.blue,
        //   fontSize: fontSize ?? 16,
        //   fontWeight: FontWeight.bold,
        // ),
      ),
    );
  }
}