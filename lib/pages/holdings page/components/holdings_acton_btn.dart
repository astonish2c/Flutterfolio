import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class HoldingsActionBtn extends StatelessWidget {
  final String text;
  final Color? btnColor;
  final Color? txtColor;
  final double? width;

  const HoldingsActionBtn({
    Key? key,
    this.btnColor,
    this.txtColor,
    required this.text,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return TextButton(
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.standard,
        backgroundColor: btnColor ?? Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: defaultPadding * 0.5,
          horizontal: deviceWidth < 380 ? defaultPadding : defaultPadding * 1.5,
        ),
      ),
      onPressed: () {},
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: txtColor ?? Colors.black,
          ),
        ),
      ),
    );
  }
}
