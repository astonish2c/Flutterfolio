import 'package:flutter/material.dart';

class PortfolioDrawerSkeleton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onClicked;

  const PortfolioDrawerSkeleton({
    required this.text,
    required this.icon,
    this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onClicked,
    );
  }
}
