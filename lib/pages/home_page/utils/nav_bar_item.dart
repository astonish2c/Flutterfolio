import 'package:flutter/material.dart';

class NavgationBarItem extends StatelessWidget {
  const NavgationBarItem({
    Key? key,
    required this.iconUrl,
    required this.label,
  }) : super(key: key);

  final IconData iconUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: SizedBox(
        height: 25,
        width: 25,
        child: Icon(
          iconUrl,
          color: Colors.black26,
        ),
      ),
      label: label,
    );
  }
}
