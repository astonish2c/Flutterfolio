import 'package:flutter/material.dart';

class ExchangePageBtn extends StatelessWidget {
  final String text;
  final int value;
  final bool show;
  final VoidCallback? onTap;
  final Color? color;

  const ExchangePageBtn({
    Key? key,
    required this.text,
    required this.value,
    required this.show,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: onTap ?? () {},
          child: Text(
            text,
            style: TextStyle(
              color: color ?? Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        if (show)
          Container(
            height: 2,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(60),
            ),
          ),
      ],
    );
  }
}
