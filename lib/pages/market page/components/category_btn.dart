import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class CategoryBtn extends StatelessWidget {
  final String text;
  final Color? bgColor;
  final Color? textColor;

  const CategoryBtn({
    Key? key,
    required this.text,
    required this.bgColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextButton(
          onPressed: () {},
          child: Text(
            deviceWidth > 380 ? text : text.substring(0, 3),
            maxLines: 1,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
