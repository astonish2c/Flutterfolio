import 'package:flutter/material.dart';

class TabTransactionDetailsItem extends StatelessWidget {
  final VoidCallback onTap;
  final Icon icon;
  final String text;
  final Color? textColor;
  final Color? bgColor;

  const TabTransactionDetailsItem({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.text,
    required this.textColor,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: bgColor ?? Colors.grey[300],
        ),
        child: Row(
          children: [
            icon,
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
