import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavgationBarItem extends StatelessWidget {
  const NavgationBarItem({
    Key? key,
    required this.iconUrl,
    required this.label,
  }) : super(key: key);

  final String iconUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: SizedBox(
        height: 25,
        width: 25,
        child: SvgPicture.asset(
          iconUrl,
          color: Colors.white,
        ),
      ),
      label: label,
    );
  }
}
